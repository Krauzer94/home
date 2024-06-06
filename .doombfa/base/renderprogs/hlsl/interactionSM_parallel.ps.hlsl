uniform float4 rpScreenCorrectionFactor : register(c0);
uniform float4 rpDiffuseModifier : register(c2);
uniform float4 rpSpecularModifier : register(c3);
uniform float4 rpJitterTexScale : register(c55);
uniform float4 rpJitterTexOffset : register(c56);
uniform float4 rpCascadeDistances : register(c57);
uniform float4 rpShadowMatrices : register(c58);
static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
half3 sRGBToLinearRGB (half3 rgb )  {
return rgb ; 
} 
half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
static const half4 matrixCoCg1YtoRGB1X = half4( 1.0, -1.0, 0.0, 1.0 );
static const half4 matrixCoCg1YtoRGB1Y = half4( 0.0, 1.0, -0.50196078, 1.0 );
static const half4 matrixCoCg1YtoRGB1Z = half4( -1.0, -1.0, 1.00392156, 1.0 );
static half3 ConvertYCoCgToRGB (half4 YCoCg )  {
half3 rgbColor ; 

YCoCg . z = ( YCoCg . z * 31.875 ) + 1.0 ; 
YCoCg . z = 1.0 / YCoCg . z ; 
YCoCg . xy *= YCoCg . z ; 
rgbColor . x = dot4 ( YCoCg , matrixCoCg1YtoRGB1X ) ; 
rgbColor . y = dot4 ( YCoCg , matrixCoCg1YtoRGB1Y ) ; 
rgbColor . z = dot4 ( YCoCg , matrixCoCg1YtoRGB1Z ) ; 
return rgbColor ; 
} 
static float4 idtex2Dproj (sampler2D samp , float4 texCoords )  {return tex2Dproj ( samp , texCoords . xyw ) ; } 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
uniform sampler2D samp3 : register(s3);
uniform sampler2D samp4 : register(s4);
uniform sampler2DArrayShadow samp5 : register(s5);
uniform sampler2D samp6 : register(s6);
struct PS_IN {
half4 position : WPOS ; 
half4 texcoord0 : TEXCOORD0_centroid ; 
half4 texcoord1 : TEXCOORD1_centroid ; 
half4 texcoord2 : TEXCOORD2_centroid ; 
half4 texcoord3 : TEXCOORD3_centroid ; 
half4 texcoord4 : TEXCOORD4_centroid ; 
half4 texcoord5 : TEXCOORD5_centroid ; 
half4 texcoord6 : TEXCOORD6_centroid ; 
half4 texcoord7 : TEXCOORD7_centroid ; 
half4 texcoord8 : TEXCOORD8_centroid ; 
half4 texcoord9 : TEXCOORD9_centroid ; 
half4 color : COLOR0 ; 
} ;
struct PS_OUT {
half4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
half4 bumpMap = tex2D ( samp0 , fragment . texcoord1 . xy ) ; 
half4 lightFalloff = ( idtex2Dproj ( samp3 , fragment . texcoord2 ) ) ; 
half4 lightProj = ( idtex2Dproj ( samp4 , fragment . texcoord3 ) ) ; 
half4 YCoCG = tex2D ( samp2 , fragment . texcoord4 . xy ) ; 
half4 specMapSRGB = tex2D ( samp1 , fragment . texcoord5 . xy ) ; 
half4 specMap = sRGBAToLinearRGBA ( specMapSRGB ) ; 

half3 lightVector = normalize ( fragment . texcoord0 . xyz ) ; 
half3 viewVector = normalize ( fragment . texcoord6 . xyz ) ; 
half3 diffuseMap = sRGBToLinearRGB ( ConvertYCoCgToRGB ( YCoCG ) ) ; 

half3 localNormal ; 
localNormal . xy = bumpMap . wy - 0.5 ; 

localNormal . z = sqrt ( abs ( dot ( localNormal . xy , localNormal . xy ) - 0.25 ) ) ; 
localNormal = normalize ( localNormal ) ; 


half ldotN = saturate ( dot3 ( localNormal , lightVector ) ) ; 

half halfLdotN = dot3 ( localNormal , lightVector ) * 0.5 + 0.5 ; 
halfLdotN *= halfLdotN ; 


half lambert = lerp ( ldotN , halfLdotN , 0.5 ) ; 





int shadowIndex = 0 ; 

float viewZ = - fragment . texcoord9 . z ; 

shadowIndex = 4 ; 
for ( int i = 0 ; i < 4 ; i ++ ) 
{ 
if ( viewZ < rpCascadeDistances [ i ] ) 
{ 
shadowIndex = i ; 
break ; 
} 
} 

float4 shadowMatrixX = rpShadowMatrices [ int ( shadowIndex * 4 + 0 ) ] ; 
float4 shadowMatrixY = rpShadowMatrices [ int ( shadowIndex * 4 + 1 ) ] ; 
float4 shadowMatrixZ = rpShadowMatrices [ int ( shadowIndex * 4 + 2 ) ] ; 
float4 shadowMatrixW = rpShadowMatrices [ int ( shadowIndex * 4 + 3 ) ] ; 

float4 modelPosition = float4 ( fragment . texcoord7 . xyz , 1.0 ) ; 
float4 shadowTexcoord ; 
shadowTexcoord . x = dot4 ( modelPosition , shadowMatrixX ) ; 
shadowTexcoord . y = dot4 ( modelPosition , shadowMatrixY ) ; 
shadowTexcoord . z = dot4 ( modelPosition , shadowMatrixZ ) ; 
shadowTexcoord . w = dot4 ( modelPosition , shadowMatrixW ) ; 

float bias = 0.001 * tan ( acos ( ldotN ) ) ; 
bias = clamp ( bias , 0.0 , 0.01 ) ; 


shadowTexcoord . xyz /= shadowTexcoord . w ; 

shadowTexcoord . z = shadowTexcoord . z * rpScreenCorrectionFactor . w ; 

shadowTexcoord . z = shadowTexcoord . z - bias ; 
shadowTexcoord . w = float ( shadowIndex ) ; 

const float2 poissonDisk [ 12 ] = float2 [ ] ( 
float2 ( 0.6111618 , 0.1050905 ) , 
float2 ( 0.1088336 , 0.1127091 ) , 
float2 ( 0.3030421 , - 0.6292974 ) , 
float2 ( 0.4090526 , 0.6716492 ) , 
float2 ( - 0.1608387 , - 0.3867823 ) , 
float2 ( 0.7685862 , - 0.6118501 ) , 
float2 ( - 0.1935026 , - 0.856501 ) , 
float2 ( - 0.4028573 , 0.07754025 ) , 
float2 ( - 0.6411021 , - 0.4748057 ) , 
float2 ( - 0.1314865 , 0.8404058 ) , 
float2 ( - 0.7005203 , 0.4596822 ) , 
float2 ( - 0.9713828 , - 0.06329931 ) ) ; 

float shadow = 0.0 ; 


float numSamples = 12.0 ; 
float stepSize = 1.0 / numSamples ; 

float4 jitterTC = ( fragment . position * rpScreenCorrectionFactor ) + rpJitterTexOffset ; 
float4 random = tex2D ( samp6 , jitterTC . xy ) * 3.14159265358979323846 ; 


float2 rot ; 
rot . x = cos ( random . x ) ; 
rot . y = sin ( random . x ) ; 

float shadowTexelSize = rpScreenCorrectionFactor . z * rpJitterTexScale . x ; 
for ( int i = 0 ; i < 12 ; i ++ ) 
{ 
float2 jitter = poissonDisk [ i ] ; 
float2 jitterRotated ; 
jitterRotated . x = jitter . x * rot . x - jitter . y * rot . y ; 
jitterRotated . y = jitter . x * rot . y + jitter . y * rot . x ; 

float4 shadowTexcoordJittered = float4 ( shadowTexcoord . xy + jitterRotated * shadowTexelSize , shadowTexcoord . z , shadowTexcoord . w ) ; 

shadow += texture ( samp5 , shadowTexcoordJittered . xywz ) ; 
} 

shadow *= stepSize ; 


half3 halfAngleVector = normalize ( lightVector + viewVector ) ; 
half hdotN = clamp ( dot3 ( halfAngleVector , localNormal ) , 0.0 , 1.0 ) ; 




const half specularPower = 10.0 ; 


half3 specularContribution = half3 ( pow ( hdotN , specularPower ) ) ; 

half3 diffuseColor = diffuseMap * sRGBToLinearRGB ( rpDiffuseModifier . xyz ) ; 
half3 specularColor = specMap . xyz * specularContribution * sRGBToLinearRGB ( rpSpecularModifier . xyz ) ; 
half3 lightColor = sRGBToLinearRGB ( lightProj . xyz * lightFalloff . xyz ) ; 






result . color . xyz = ( diffuseColor + specularColor ) * lambert * lightColor * fragment . color . rgb * shadow ; 

result . color . w = 1.0 ; 
} 
