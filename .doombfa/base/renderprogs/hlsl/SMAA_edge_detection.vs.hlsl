uniform float4 rpScreenCorrectionFactor : register(c0);
void SMAAEdgeDetectionVS (float2 texcoord , 
out float4 offset [ 3 ] )  {
offset [ 0 ] = ( rpScreenCorrectionFactor . xyxy * float4 ( - 1.0 , 0.0 , 0.0 , - 1.0 ) + texcoord . xyxy ) ; 
offset [ 1 ] = ( rpScreenCorrectionFactor . xyxy * float4 ( 1.0 , 0.0 , 0.0 , 1.0 ) + texcoord . xyxy ) ; 
offset [ 2 ] = ( rpScreenCorrectionFactor . xyxy * float4 ( - 2.0 , 0.0 , 0.0 , - 2.0 ) + texcoord . xyxy ) ; 
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
float4 texcoord2 : TEXCOORD2 ; 
float4 texcoord3 : TEXCOORD3 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position = vertex . position ; 

float2 texcoord = vertex . texcoord ; 


result . texcoord0 = texcoord ; 

float4 offset [ 3 ] ; 
SMAAEdgeDetectionVS ( texcoord , offset ) ; 

result . texcoord1 = offset [ 0 ] ; 
result . texcoord2 = offset [ 1 ] ; 
result . texcoord3 = offset [ 2 ] ; 
} 
