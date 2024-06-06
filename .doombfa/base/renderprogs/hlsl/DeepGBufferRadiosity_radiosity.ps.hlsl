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
const float projScale = 500.0;
uniform sampler2D samp0 : register( s0 );
uniform sampler2D samp1 : register( s1 );
uniform sampler2D samp2 : register( s2 );
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
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
float3 sampleNormal (sampler2D normalBuffer , int2 ssC , int mipLevel )  {
return texelFetch ( normalBuffer , ssC , mipLevel ) . xyz * 2.0 - 1.0 ; 
} 
float2 tapLocation (int sampleNumber , float spinAngle , float radialJitter , out float ssR )  {

float alpha = ( float ( sampleNumber ) + radialJitter ) * ( 1.0 / float ( 11 ) ) ; 
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
void computeMipInfo (float ssR , int2 ssP , sampler2D cszBuffer , inout int mipLevel , inout int2 mipP )  {
mipLevel = clamp ( int ( floor ( log2 ( ssR ) ) ) - ( 3 ) , 0 , ( 5 ) ) ; 





mipP = clamp ( ssP >> mipLevel , int2 ( 0 ) , textureSize ( cszBuffer , mipLevel ) - int2 ( 1 ) ) ; 
} 
void getOffsetPositionNormalAndLambertian (int2 ssP , 
float ssR , 
sampler2D cszBuffer , 
sampler2D bounceBuffer , 
sampler2D normalBuffer , 
inout float3 Q , 
inout float3 lambertian_tap , 
inout float3 n_tap )  {
int mipLevel ; 
int2 texel ; 
computeMipInfo ( ssR , ssP , cszBuffer , mipLevel , texel ) ; 

float z = texelFetch ( cszBuffer , texel , mipLevel ) . r ; 
float3 n = sampleNormal ( normalBuffer , ssP , 0 ) ; 
lambertian_tap = texelFetch ( bounceBuffer , ssP , 0 ) . rgb ; 


n_tap = n ; 


Q = reconstructCSPosition ( ( float2 ( ssP ) + float2 ( 0.5 ) ) , z ) ; 
} 
void iiValueFromPositionsAndNormalsAndLambertian (int2 ssP , float3 X , float3 n_X , float3 Y , float3 n_Y , float3 radiosity_Y , inout float3 E , inout float weight_Y , inout float visibilityWeight_Y )  {

float3 YminusX = Y - X ; 
float3 w_i = normalize ( YminusX ) ; 
weight_Y = ( ( dot ( w_i , n_X ) > 0.0 ) 
&& ( dot ( - w_i , n_Y ) > 0.01 ) 
) ? 1.0 : 0.0 ; 



if ( ( dot ( YminusX , YminusX ) < radius2 ) && 
( weight_Y > 0.0 ) ) 
{ 
E = radiosity_Y * dot ( w_i , n_X ) ; 
} 
else 
{ 
E = float3 ( 0 ) ; 
} 
} 
void sampleIndirectLight (in int2 ssC , 
in float3 C , 
in float3 n_C , 
in float3 C_peeled , 
in float3 n_C_peeled , 
in float ssDiskRadius , 
in int tapIndex , 
in float randomPatternRotationAngle , 
in float radialJitter , 
in sampler2D cszBuffer , 
in sampler2D nBuffer , 
in sampler2D bounceBuffer , 
inout float3 irradianceSum , 
inout float numSamplesUsed , 
inout float3 iiPeeled , 
inout float weightSumPeeled )  {


float visibilityWeightPeeled0 , visibilityWeightPeeled1 ; 


float ssR ; 
float2 unitOffset = tapLocation ( tapIndex , randomPatternRotationAngle , radialJitter , ssR ) ; 
ssR *= ssDiskRadius ; 
int2 ssP = int2 ( ssR * unitOffset ) + ssC ; 

float3 E ; 
float visibilityWeight ; 
float weight_Y ; 

float3 Q , lambertian_tap , n_tap ; 
getOffsetPositionNormalAndLambertian ( ssP , ssR , cszBuffer , bounceBuffer , nBuffer , Q , lambertian_tap , n_tap ) ; 
iiValueFromPositionsAndNormalsAndLambertian ( ssP , C , n_C , Q , n_tap , lambertian_tap , E , weight_Y , visibilityWeight ) ; 
numSamplesUsed += weight_Y ; 

irradianceSum += E ; 

} 
void main (PS_IN fragment , out PS_OUT result )  {
result . color = float4 ( 0.0 , 0.0 , 0.0 , 1.0 ) ; 


int2 ssC = int2 ( gl_FragCoord . xy ) ; 

float3 C = getPosition ( ssC , samp1 ) ; 
float3 C_peeled = float3 ( 0 ) ; 
float3 n_C_peeled = float3 ( 0 ) ; 

float3 n_C = sampleNormal ( samp0 , ssC , 0 ) ; 





float ssDiskRadius = - projScale * radius / C . z ; 


float randomPatternRotationAngle = float ( 3 * ssC . x ^ ssC . y + ssC . x * ssC . y ) * 10.0 ; 

float radialJitter = fract ( sin ( gl_FragCoord . x * 1e2 + 
gl_FragCoord . y ) * 1e5 + sin ( gl_FragCoord . y * 1e3 ) * 1e3 ) * 0.8 + 0.1 ; 

float numSamplesUsed = 0.0 ; 
float3 irradianceSum = float3 ( 0 ) ; 
float3 ii_peeled = float3 ( 0 ) ; 
float peeledSum = 0.0 ; 
for ( int i = 0 ; i < 11 ; ++ i ) 
{ 
sampleIndirectLight ( ssC , C , n_C , C_peeled , n_C_peeled , ssDiskRadius , i , randomPatternRotationAngle , radialJitter , samp1 , samp0 , samp2 , irradianceSum , numSamplesUsed , ii_peeled , peeledSum ) ; 
} 

const float solidAngleHemisphere = 2.0 * 3.14159265358979323846 ; 
float3 E_X = irradianceSum * solidAngleHemisphere / ( numSamplesUsed + 0.00001 ) ; 

result . color . rgb = E_X ; 



result . color . a = 1.0 - numSamplesUsed / float ( 11 ) ; 
} 
