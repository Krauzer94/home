uniform float4 rpScreenCorrectionFactor : register(c0);
uniform float4 rpModelMatrixX : register(c25);
uniform float4 rpModelMatrixY : register(c26);
uniform float4 rpModelMatrixZ : register(c27);
uniform float4 rpModelMatrixW : register(c28);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
const float DOOM_TO_METERS = 0.0254;
const float METERS_TO_DOOM = ( 1.0 / DOOM_TO_METERS );
const float radius = 1.0 * METERS_TO_DOOM;
const float radius2 = radius * radius;
const float invRadius2 = 1.0 / radius2;
const float bias = 0.01 * METERS_TO_DOOM;
const float intensity = 0.6;
const float projScale = 500.0;
uniform sampler2D samp0 : register( s0 );
uniform sampler2D samp1 : register( s1 );
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
float3 reconstructCSPosition (float2 S , float z )  {
float4 P ; 



P = float4 ( S * rpScreenCorrectionFactor . xy , z , 1.0 ) * 4.0 - 1.0 ; 

float4 csP ; 
csP . x = dot4 ( P , rpModelMatrixX ) ; 
csP . y = dot4 ( P , rpModelMatrixY ) ; 
csP . z = dot4 ( P , rpModelMatrixZ ) ; 
csP . w = dot4 ( P , rpModelMatrixW ) ; 

csP . xyz /= csP . w ; 

return ( csP . xyz * 0.5 ) + 0.5 ; 
} 
float3 sampleNormal (sampler2D normalBuffer , int2 ssC , int mipLevel )  {
return texelFetch ( normalBuffer , ssC , mipLevel ) . xyz * 2.0 - 1.0 ; 
} 
float2 tapLocation (int sampleNumber , float spinAngle , out float ssR )  {

float alpha = ( float ( sampleNumber ) + 0.5 ) * ( 1.0 / float ( 11 ) ) ; 
float angle = alpha * ( float ( 7 ) * 6.28 ) + spinAngle ; 

ssR = alpha ; 
return float2 ( cos ( angle ) , sin ( angle ) ) ; 
} 
float3 getPosition (int2 ssP , sampler2D cszBuffer )  {
float3 P ; 
P . z = texelFetch ( cszBuffer , ssP , 0 ) . r ; 


P = reconstructCSPosition ( float2 ( ssP ) + float2 ( 0.5 ) , P . z ) ; 

return P ; 
} 
void computeMipInfo (float ssR , int2 ssP , sampler2D cszBuffer , out int mipLevel , out int2 mipP )  {
mipLevel = clamp ( int ( floor ( log2 ( ssR ) ) ) - ( 3 ) , 0 , ( 5 ) ) ; 







mipP = clamp ( ssP >> mipLevel , int2 ( 0 ) , textureSize ( cszBuffer , mipLevel ) - int2 ( 1 ) ) ; 
} 
float3 getOffsetPosition (int2 issC , float2 unitOffset , float ssR , sampler2D cszBuffer , float invCszBufferScale )  {
int2 ssP = int2 ( ssR * unitOffset ) + issC ; 

float3 P ; 

int mipLevel ; 
int2 mipP ; 
computeMipInfo ( ssR , ssP , cszBuffer , mipLevel , mipP ) ; 



P . z = texelFetch ( cszBuffer , mipP , mipLevel ) . r ; 


P = reconstructCSPosition ( float2 ( ssP ) + float2 ( 0.5 ) , P . z ) ; 


return P ; 
} 
float fallOffFunction (float vv , float vn , float epsilon )  {

float f = max ( 1.0 - vv * invRadius2 , 0.0 ) ; 
return f * max ( ( vn - bias ) * rsqrt ( epsilon + vv ) , 0.0 ) ; 









} 
float aoValueFromPositionsAndNormal (float3 C , float3 n_C , float3 Q )  {
float3 v = Q - C ; 

float vv = dot ( v , v ) ; 
float vn = dot ( v , n_C ) ; 
const float epsilon = 0.001 ; 


return fallOffFunction ( vv , vn , epsilon ) * lerp ( 1.0 , max ( 0.0 , 1.5 * n_C . z ) , 0.35 ) ; 
} 
float sampleAO (int2 issC , in float3 C , in float3 n_C , in float ssDiskRadius , in int tapIndex , in float randomPatternRotationAngle , in sampler2D cszBuffer , in float invCszBufferScale )  {

float ssR ; 
float2 unitOffset = tapLocation ( tapIndex , randomPatternRotationAngle , ssR ) ; 


ssR = max ( 0.75 , ssR * ssDiskRadius ) ; 

float3 Q = getOffsetPosition ( issC , unitOffset , ssR , cszBuffer , invCszBufferScale ) ; 

return aoValueFromPositionsAndNormal ( C , n_C , Q ) ; 
} 
const float MIN_RADIUS = 3.0;
void main (PS_IN fragment , out PS_OUT result )  {
result . color = float4 ( 1.0 , 0.0 , 0.0 , 1.0 ) ; 





int2 ssP = int2 ( gl_FragCoord . xy ) ; 


float3 C = getPosition ( ssP , samp1 ) ; 

result . color . r = 0.0 ; 
float3 n_C = sampleNormal ( samp0 , ssP , 0 ) ; 

if ( length ( n_C ) < 0.01 ) 
{ 
result . color . r = 1.0 ; 
return ; 
} 

n_C = normalize ( n_C ) ; 


float randomPatternRotationAngle = float ( ( ( 3 * ssP . x ) ^ ( ssP . y + ssP . x * ssP . y ) ) 
) * 10.0 ; 



float ssDiskRadius = - projScale * radius / C . z ; 
if ( ssDiskRadius <= MIN_RADIUS ) 
{ 

result . color . r = 1.0 ; 
return ; 
} 

float sum = 0.0 ; 
for ( int i = 0 ; i < 11 ; ++ i ) 
{ 
sum += sampleAO ( ssP , C , n_C , ssDiskRadius , i , randomPatternRotationAngle , samp1 , 1.0 ) ; 
} 
float A = pow ( max ( 0.0 , 1.0 - sqrt ( sum * ( 3.0 / float ( 11 ) ) ) ) , intensity ) ; 





result . color . r = lerp ( 1.0 , A , saturate ( ssDiskRadius - MIN_RADIUS ) ) ; 
} 
