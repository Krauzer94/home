uniform float4 rpAlphaTest : register(c52);
half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float4 color = tex2D ( samp0 , fragment . texcoord0 ) * fragment . color ; 
clip ( color . a - rpAlphaTest . x ) ; 
result . color = sRGBAToLinearRGBA ( color ) ; 
} 
