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
static float2 Rotate2D (float2 inTC , float2 cs )  {
float sinValue = cs . y ; 
float cosValue = cs . x ; 

float4 tc0 = float4 ( cosValue , - sinValue , 0 , ( - 0.5 * cosValue ) + ( 0.5 * sinValue ) + 0.5 ) ; 
float4 tc1 = float4 ( sinValue , cosValue , 0 , ( - 0.5 * sinValue ) + ( - 0.5 * cosValue ) + 0.5 ) ; 

float2 finalTC ; 
finalTC . x = dot4 ( inTC , tc0 ) ; 
finalTC . y = dot4 ( inTC , tc1 ) ; 
return finalTC ; 
} 
uniform float4 rpUser0 : register( c128 );
uniform float4 rpUser1 : register( c129 );
uniform float4 rpUser2 : register( c130 );
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
float2 texcoord2 : TEXCOORD2 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

const float4 centerScaleTex0 = rpUser0 ; 
const float4 rotateTex0 = rpUser1 ; 
const float4 centerScaleTex1 = rpUser2 ; 


float2 tc0 = CenterScale ( vertex . texcoord , centerScaleTex0 . xy ) ; 
result . texcoord0 = Rotate2D ( tc0 , rotateTex0 . xy ) ; 


result . texcoord1 = CenterScale ( vertex . texcoord , centerScaleTex1 . xy ) ; 


result . texcoord2 = vertex . texcoord ; 
} 
