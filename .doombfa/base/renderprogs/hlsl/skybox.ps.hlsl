half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
uniform samplerCUBE samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float3 texcoord0 : TEXCOORD0_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
result . color = sRGBAToLinearRGBA ( texCUBE ( samp0 , fragment . texcoord0 ) ) * fragment . color ; 
} 
