uniform float4 rpScreenCorrectionFactor : register(c0);
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
float3 ACESFilm (float3 x )  {
float a = 2.51 ; 
float b = 0.03 ; 
float c = 2.43 ; 
float d = 0.59 ; 
float e = 0.14 ; 
return saturate ( ( x * ( a * x + b ) ) / ( x * ( c * x + d ) + e ) ) ; 
} 
void main (PS_IN fragment , out PS_OUT result )  {
float2 tCoords = fragment . texcoord0 ; 

float4 color = tex2D ( samp0 , tCoords ) ; 


float Y = dot ( LUMINANCE_SRGB , color ) ; 

const float hdrGamma = 2.2 ; 
float gamma = hdrGamma ; 

float hdrKey = rpScreenCorrectionFactor . x ; 
float hdrAverageLuminance = rpScreenCorrectionFactor . y ; 
float hdrMaxLuminance = rpScreenCorrectionFactor . z ; 


float Yr = ( hdrKey * Y ) / hdrAverageLuminance ; 

float Ymax = hdrMaxLuminance ; 




float avgLuminance = max ( hdrAverageLuminance , 0.001 ) ; 
float linearExposure = ( hdrKey / avgLuminance ) ; 
float exposure = log2 ( max ( linearExposure , 0.0001 ) ) ; 


float3 exposedColor = exp2 ( exposure ) * color . rgb ; 

color . rgb = ACESFilm ( exposedColor ) ; 



gamma = 1.0 / hdrGamma ; 
color . r = pow ( color . r , gamma ) ; 
color . g = pow ( color . g , gamma ) ; 
color . b = pow ( color . b , gamma ) ; 

color = tex2D ( samp1 , float2 ( dot ( LUMINANCE_SRGB , color ) , 0.0 ) ) ; 

result . color = color ; 
} 
