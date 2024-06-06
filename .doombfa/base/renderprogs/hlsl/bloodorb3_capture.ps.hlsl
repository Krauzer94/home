uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float2 texcoord1 : TEXCOORD1_centroid ; 
float2 texcoord2 : TEXCOORD2_centroid ; 
float2 texcoord3 : TEXCOORD3_centroid ; 
float2 texcoord4 : TEXCOORD4 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float colorFactor = fragment . texcoord4 . x ; 

float4 color0 = float4 ( 1.0 - colorFactor , 1.0 - colorFactor , 1.0 , 1.0 ) ; 
float4 color1 = float4 ( 1.0 , 0.95 - colorFactor , 0.95 , 0.5 ) ; 
float4 color2 = float4 ( 0.015 , 0.015 , 0.015 , 0.01 ) ; 

float4 accumSample0 = tex2D ( samp0 , fragment . texcoord0 ) * color0 ; 
float4 accumSample1 = tex2D ( samp0 , fragment . texcoord1 ) * color1 ; 
float4 accumSample2 = tex2D ( samp0 , fragment . texcoord2 ) * color2 ; 
float4 maskSample = tex2D ( samp2 , fragment . texcoord3 ) ; 

float4 tint = float4 ( 0.8 , 0.5 , 0.5 , 1 ) ; 
float4 currentRenderSample = tex2D ( samp1 , fragment . texcoord3 ) * tint ; 


float4 accumColor = lerp ( accumSample0 , accumSample1 , 0.5 ) ; 

accumColor += accumSample2 ; 

accumColor = lerp ( accumColor , currentRenderSample , maskSample . a ) ; 
result . color = accumColor ; 
} 
