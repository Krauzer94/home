uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

float4 accumSample = tex2D ( samp0 , fragment . texcoord0 ) ; 
float4 currentRenderSample = tex2D ( samp1 , fragment . texcoord0 ) ; 
float4 maskSample = tex2D ( samp2 , fragment . texcoord0 ) ; 

result . color = lerp ( accumSample , currentRenderSample , maskSample . a ) ; 
} 
