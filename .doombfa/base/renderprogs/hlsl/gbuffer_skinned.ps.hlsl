static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float3 texcoord1 : TEXCOORD1_centroid ; 
float3 texcoord2 : TEXCOORD2_centroid ; 
float3 texcoord3 : TEXCOORD3_centroid ; 
float3 texcoord4 : TEXCOORD4_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float4 bump = tex2D ( samp0 , fragment . texcoord0 ) * 2.0 - 1.0 ; 


float3 localNormal ; 
localNormal = float3 ( bump . wy , 0.0 ) ; 

localNormal . z = sqrt ( 1.0 - dot3 ( localNormal , localNormal ) ) ; 

float3 globalNormal ; 
globalNormal . x = dot3 ( localNormal , fragment . texcoord2 ) ; 
globalNormal . y = dot3 ( localNormal , fragment . texcoord3 ) ; 
globalNormal . z = dot3 ( localNormal , fragment . texcoord4 ) ; 


result . color . rgb = ( globalNormal . xyz * 0.5 + 0.5 ) * fragment . color . rgb ; 

result . color . a = 1.0 ; 
} 
