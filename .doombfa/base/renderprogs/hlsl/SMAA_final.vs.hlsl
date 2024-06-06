uniform float4 rpScreenCorrectionFactor : register(c0);
void SMAANeighborhoodBlendingVS (float2 texcoord , 
out float4 offset )  {
offset = ( rpScreenCorrectionFactor . xyxy * float4 ( 1.0 , 0.0 , 0.0 , 1.0 ) + texcoord . xyxy ) ; 
} 
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
float4 texcoord1 : TEXCOORD1 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position = vertex . position ; 

result . texcoord0 = vertex . texcoord ; 

float4 offset ; 
SMAANeighborhoodBlendingVS ( vertex . texcoord , offset ) ; 

result . texcoord1 = offset ; 
} 
