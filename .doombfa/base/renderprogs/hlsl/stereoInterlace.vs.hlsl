uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
struct VS_IN {
float4 position : POSITION ; 
float2 texcoord : TEXCOORD0 ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
float2 texcoord0 : TEXCOORD0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

result . texcoord0 = vertex . texcoord ; 
} 
