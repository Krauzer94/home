uniform sampler2D samp0 : register( s0 );
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float2 ssC = fragment . texcoord0 ; 
float depth = tex2D ( samp0 , ssC ) . r ; 

result . color . r = depth ; 
} 
