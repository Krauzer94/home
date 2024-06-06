uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float4 color = ( tex2D ( samp0 , fragment . texcoord0 ) * fragment . color ) + fragment . texcoord1 ; 
result . color . xyz = color . xyz * color . w ; 
result . color . w = color . w ; 
} 
