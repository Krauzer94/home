uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
static float2 CenterScale (float2 inTC , float2 centerScale )  {
float scaleX = centerScale . x ; 
float scaleY = centerScale . y ; 
float4 tc0 = float4 ( scaleX , 0 , 0 , 0.5 - ( 0.5 * scaleX ) ) ; 
float4 tc1 = float4 ( 0 , scaleY , 0 , 0.5 - ( 0.5 * scaleY ) ) ; 

float2 finalTC ; 
finalTC . x = dot4 ( inTC , tc0 ) ; 
finalTC . y = dot4 ( inTC , tc1 ) ; 
return finalTC ; 
} 
uniform float4 rpUser0 : register( c128 );
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
float2 texcoord1 : TEXCOORD1 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 


const float4 centerScale = rpUser0 ; 
result . texcoord0 = CenterScale ( vertex . texcoord , centerScale . xy ) ; 


result . texcoord1 = vertex . texcoord ; 
} 
