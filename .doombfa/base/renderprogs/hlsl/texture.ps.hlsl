uniform float4 rpColor : register(c18);
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
result . color = tex2D ( samp0 , fragment . texcoord0 ) * rpColor ; 


} 
