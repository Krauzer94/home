uniform float4 rpLocalViewOrigin : register(c5);
uniform float4 rpVertexColorModulate : register(c16);
uniform float4 rpVertexColorAdd : register(c17);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpWobbleSkyX : register(c47);
uniform float4 rpWobbleSkyY : register(c48);
uniform float4 rpWobbleSkyZ : register(c49);
static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
static float4 swizzleColor (float4 c )  {
return c ; 

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
float3 texcoord0 : TEXCOORD0 ; 
float4 color : COLOR0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

float3 t0 = vertex . position . xyz - rpLocalViewOrigin . xyz ; 
result . texcoord0 . x = dot3 ( t0 , rpWobbleSkyX ) ; 
result . texcoord0 . y = dot3 ( t0 , rpWobbleSkyY ) ; 
result . texcoord0 . z = dot3 ( t0 , rpWobbleSkyZ ) ; 

result . color = ( swizzleColor ( vertex . color ) * rpVertexColorModulate ) + rpVertexColorAdd ; 
} 
