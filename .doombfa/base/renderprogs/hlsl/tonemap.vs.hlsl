struct VS_IN {
float4 position : POSITION ; 
float2 texcoord : TEXCOORD0 ; 
float4 normal : NORMAL ; 
float4 tangent : TANGENT ; 
float4 color : COLOR0 ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
float2 texcoord0 : TEXCOORD0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position = vertex . position ; 





result . texcoord0 = vertex . texcoord ; 
} 
