uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

if ( fract ( fragment . position . y * 0.5 ) < 0.5 ) { 
result . color = tex2D ( samp0 , vec2 ( fragment . texcoord0 ) ) ; 
} else { 
result . color = tex2D ( samp1 , vec2 ( fragment . texcoord0 ) ) ; 
} 
} 
