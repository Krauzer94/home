uniform float4 rpScreenCorrectionFactor : register(c0);
uniform float4 rpJitterTexOffset : register(c56);
static const half4 LUMINANCE_SRGB = half4( 0.2125, 0.7154, 0.0721, 0.0 );
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
float3 overlay (float3 a , float3 b )  {



return float3 ( 
b . x < 0.5 ? ( 2.0 * a . x * b . x ) : ( 1.0 - 2.0 * ( 1.0 - a . x ) * ( 1.0 - b . x ) ) , 
b . y < 0.5 ? ( 2.0 * a . y * b . y ) : ( 1.0 - 2.0 * ( 1.0 - a . y ) * ( 1.0 - b . y ) ) , 
b . z < 0.5 ? ( 2.0 * a . z * b . z ) : ( 1.0 - 2.0 * ( 1.0 - a . z ) * ( 1.0 - b . z ) ) ) ; 
} 
void TechnicolorPass (inout float4 color )  {
const float3 cyanFilter = float3 ( 0.0 , 1.30 , 1.0 ) ; 
const float3 magentaFilter = float3 ( 1.0 , 0.0 , 1.05 ) ; 
const float3 yellowFilter = float3 ( 1.6 , 1.6 , 0.05 ) ; 
const float3 redOrangeFilter = float3 ( 1.05 , 0.62 , 0.0 ) ; 
const float3 greenFilter = float3 ( 0.3 , 1.0 , 0.0 ) ; 

float2 redNegativeMul = color . rg * ( 1.0 / ( 0.88 * 4.0 ) ) ; 
float2 greenNegativeMul = color . rg * ( 1.0 / ( 0.88 * 4.0 ) ) ; 
float2 blueNegativeMul = color . rb * ( 1.0 / ( 0.88 * 4.0 ) ) ; 

float redNegative = dot ( redOrangeFilter . rg , redNegativeMul ) ; 
float greenNegative = dot ( greenFilter . rg , greenNegativeMul ) ; 
float blueNegative = dot ( magentaFilter . rb , blueNegativeMul ) ; 

float3 redOutput = float3 ( redNegative ) + cyanFilter ; 
float3 greenOutput = float3 ( greenNegative ) + magentaFilter ; 
float3 blueOutput = float3 ( blueNegative ) + yellowFilter ; 

float3 result = redOutput * greenOutput * blueOutput ; 
color . rgb = lerp ( color . rgb , result , 0.5 ) ; 
} 
void VibrancePass (inout float4 color )  {
const float3 vibrance = float3 ( 1.0 , 1.0 , 1.0 ) * 0.5 ; 

float Y = dot ( LUMINANCE_SRGB , color ) ; 

float minColor = min ( color . r , min ( color . g , color . b ) ) ; 
float maxColor = max ( color . r , max ( color . g , color . b ) ) ; 

float colorSat = maxColor - minColor ; 

color . rgb = lerp ( float3 ( Y ) , color . rgb , ( 1.0 + ( vibrance * ( 1.0 - ( sign ( vibrance ) * colorSat ) ) ) ) ) ; 
} 
void FilmgrainPass (inout float4 color )  {
float4 jitterTC = ( fragment . position * rpScreenCorrectionFactor ) + rpJitterTexOffset ; 




float4 noiseColor = tex2D ( samp1 , fragment . position . xy + jitterTC . xy ) ; 
float Y = noiseColor . r ; 



float exposureFactor = 1.0 ; 
exposureFactor = sqrt ( exposureFactor ) ; 
const float noiseIntensity = 1.7 ; 

float t = lerp ( 3.5 * noiseIntensity , 1.13 * noiseIntensity , exposureFactor ) ; 
color . rgb = overlay ( color . rgb , lerp ( float3 ( 0.5 ) , noiseColor . rgb , t ) ) ; 



} 
void main (PS_IN fragment , out PS_OUT result )  {
float2 tCoords = fragment . texcoord0 ; 


float4 color = tex2D ( samp0 , tCoords ) ; 
TechnicolorPass ( color ) ; 
VibrancePass ( color ) ; 
FilmgrainPass ( color ) ; 

result . color = color ; 
} 
