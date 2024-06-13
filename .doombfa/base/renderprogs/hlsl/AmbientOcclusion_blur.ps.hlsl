uniform float4 rpScreenCorrectionFactor : register(c0);
uniform float4 rpModelMatrixX : register(c25);
uniform float4 rpModelMatrixY : register(c26);
uniform float4 rpModelMatrixZ : register(c27);
uniform float4 rpModelMatrixW : register(c28);
uniform float4 rpJitterTexScale : register(c55);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
uniform sampler2D samp0 : register( s0 );
uniform sampler2D samp1 : register( s1 );
uniform sampler2D samp2 : register( s2 );
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
float3 sampleNormal (sampler2D normalBuffer , int2 ssC , int mipLevel )  {
return normalize ( texelFetch ( normalBuffer , ssC , mipLevel ) . xyz * 2.0 - 1.0 ) ; 
} 
const float FAR_PLANE_Z = -16000.0;
float CSZToKey (float z )  {
return clamp ( z * ( 1.0 / FAR_PLANE_Z ) , 0.0 , 1.0 ) ; 
} 
float3 reconstructCSPosition (float2 S , float z )  {
float4 P ; 
P . z = z * 2.0 - 1.0 ; 
P . xy = ( S * rpScreenCorrectionFactor . xy ) * 2.0 - 1.0 ; 
P . w = 1.0 ; 

float4 csP ; 
csP . x = dot4 ( P , rpModelMatrixX ) ; 
csP . y = dot4 ( P , rpModelMatrixY ) ; 
csP . z = dot4 ( P , rpModelMatrixZ ) ; 
csP . w = dot4 ( P , rpModelMatrixW ) ; 

csP . xyz /= csP . w ; 

return csP . xyz ; 
} 
float getKey (int2 ssP )  {
float key = texelFetch ( samp1 , ssP , 0 ) . r ; 
float3 P = reconstructCSPosition ( float2 ( ssP ) + float2 ( 0.5 ) , key ) ; 
key = P . z ; 

key = clamp ( key * ( 1.0 / FAR_PLANE_Z ) , 0.0 , 1.0 ) ; 
return key ; 
} 
float3 getPosition (int2 ssP , sampler2D samp1 )  {
float3 P ; 
P . z = texelFetch ( samp1 , ssP , 0 ) . r ; 


P = reconstructCSPosition ( float2 ( ssP ) + float2 ( 0.5 ) , P . z ) ; 

return P ; 
} 
float calculateBilateralWeight (float key , float tapKey , int2 tapLoc , float3 n_C , float3 C )  {

float depthWeight = max ( 0.0 , 1.0 - ( ( 1.0 ) * 2000.0 ) * abs ( tapKey - key ) ) ; 

float k_normal = 1.0 ; 
float k_plane = 1.0 ; 


float normalWeight = 1.0 ; 
float planeWeight = 1.0 ; 
float3 tapN_C = sampleNormal ( samp0 , tapLoc , 0 ) ; 
depthWeight = 1.0 ; 

float normalError = 1.0 - dot ( tapN_C , n_C ) * k_normal ; 
normalWeight = max ( ( 1.0 - ( 1.0 ) * normalError ) , 0.00 ) ; 

float lowDistanceThreshold2 = 0.001 ; 


float3 tapC = getPosition ( tapLoc , samp1 ) ; 


float3 dq = C - tapC ; 



float distance2 = dot ( dq , dq ) ; 


float planeError = max ( abs ( dot ( dq , tapN_C ) ) , abs ( dot ( dq , n_C ) ) ) ; 

planeWeight = ( distance2 < lowDistanceThreshold2 ) ? 1.0 : 
pow ( max ( 0.0 , 1.0 - ( 1.0 ) * 2.0 * k_plane * planeError / sqrt ( distance2 ) ) , 2.0 ) ; 

return depthWeight * normalWeight * planeWeight ; 
} 
void main (PS_IN fragment , out PS_OUT result )  {


float kernel [ ( 4 ) + 1 ] ; 
kernel [ 0 ] = 0.153170 ; 
kernel [ 1 ] = 0.144893 ; 
kernel [ 2 ] = 0.122649 ; 
kernel [ 3 ] = 0.092902 ; 
kernel [ 4 ] = 0.062970 ; 


int2 ssC = int2 ( gl_FragCoord . xy ) ; 

float4 temp = texelFetch ( samp2 , ssC , 0 ) ; 
float3 C = getPosition ( ssC , samp1 ) ; 
float key = CSZToKey ( C . z ) ; 

float sum = temp . r ; 

if ( key == 1.0 ) 
{ 

result . color . r = sum ; 
return ; 
} 



float BASE = kernel [ 0 ] ; 
float totalWeight = BASE ; 
sum *= totalWeight ; 

float3 n_C ; 
n_C = sampleNormal ( samp0 , ssC , 0 ) ; 
for ( int r = - ( 4 ) ; r <= ( 4 ) ; ++ r ) 
{ 


if ( r != 0 ) 
{ 
int2 tapLoc = ssC + int2 ( rpJitterTexScale . xy ) * ( r * ( 2 ) ) ; 
temp = texelFetch ( samp2 , tapLoc , 0 ) ; 


float tapKey = getKey ( tapLoc ) ; 
float value = temp . r ; 


float weight = 0.3 + kernel [ abs ( r ) ] ; 

float bilateralWeight = calculateBilateralWeight ( key , tapKey , tapLoc , n_C , C ) ; 

weight *= bilateralWeight ; 
sum += value * weight ; 
totalWeight += weight ; 
} 
} 

const float epsilon = 0.0001 ; 
result . color . r = sum / ( totalWeight + epsilon ) ; 
} 
