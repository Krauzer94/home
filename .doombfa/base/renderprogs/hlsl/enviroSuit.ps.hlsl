uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord : TEXCOORD0_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

float2 screenTexCoord = fragment . texcoord ; 


float4 warpFactor = 1.0 - ( tex2D ( samp1 , screenTexCoord . xy ) * fragment . color ) ; 
screenTexCoord -= float2 ( 0.5 , 0.5 ) ; 
screenTexCoord *= warpFactor . xy ; 
screenTexCoord += float2 ( 0.5 , 0.5 ) ; 


result . color = tex2D ( samp0 , screenTexCoord ) ; 

} 
