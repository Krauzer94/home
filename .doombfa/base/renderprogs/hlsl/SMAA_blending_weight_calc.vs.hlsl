uniform float4 rpScreenCorrectionFactor : register(c0);
void SMAABlendingWeightCalculationVS (float2 texcoord , 
out float2 pixcoord , 
out float4 offset [ 3 ] )  {
pixcoord = texcoord * rpScreenCorrectionFactor . zw ; 


offset [ 0 ] = ( rpScreenCorrectionFactor . xyxy * float4 ( - 0.25 , - 0.125 , 1.25 , - 0.125 ) + texcoord . xyxy ) ; 
offset [ 1 ] = ( rpScreenCorrectionFactor . xyxy * float4 ( - 0.125 , - 0.25 , - 0.125 , 1.25 ) + texcoord . xyxy ) ; 


offset [ 2 ] = ( rpScreenCorrectionFactor . xxyy * 
float4 ( - 2.0 , 2.0 , - 2.0 , 2.0 ) * float ( 16 ) + 
float4 ( offset [ 0 ] . xz , offset [ 1 ] . yw ) ) ; 
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
float4 texcoord4 : TEXCOORD4 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position = vertex . position ; 

float2 texcoord = vertex . texcoord ; 

result . texcoord0 = texcoord ; 

float4 offset [ 3 ] ; 
float2 pixcoord ; 
SMAABlendingWeightCalculationVS ( texcoord , pixcoord , offset ) ; 

result . texcoord1 = offset [ 0 ] ; 
result . texcoord2 = offset [ 1 ] ; 
result . texcoord3 = offset [ 2 ] ; 

result . texcoord4 . st = pixcoord ; 
} 
