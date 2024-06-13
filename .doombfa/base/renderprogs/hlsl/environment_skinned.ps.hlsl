static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
half3 sRGBToLinearRGB (half3 rgb )  {
return rgb ; 
} 
uniform samplerCUBE samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float3 texcoord0 : TEXCOORD0_centroid ; 
float3 texcoord1 : TEXCOORD1_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

float3 globalNormal = normalize ( fragment . texcoord1 ) ; 
float3 globalEye = normalize ( fragment . texcoord0 ) ; 

float3 reflectionVector = float3 ( dot3 ( globalEye , globalNormal ) ) ; 
reflectionVector *= globalNormal ; 
reflectionVector = ( reflectionVector * 2.0 ) - globalEye ; 

float4 envMap = texCUBE ( samp0 , reflectionVector ) ; 

result . color = float4 ( sRGBToLinearRGB ( envMap . xyz ) , 1.0 ) * fragment . color ; 
} 
