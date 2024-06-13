uniform float4 rpVertexColorModulate : register(c16);
uniform float4 rpVertexColorAdd : register(c17);
uniform float4 rpColor : register(c18);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpTextureMatrixS : register(c37);
uniform float4 rpTextureMatrixT : register(c38);
uniform float4 rpTexGen0S : register(c39);
uniform float4 rpTexGen0T : register(c40);
uniform float4 rpTexGen0Q : register(c41);
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
float4 texcoord0 : TEXCOORD0 ; 
float4 color : COLOR0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

float4 tc0 ; 
tc0 . x = dot4 ( vertex . position , rpTexGen0S ) ; 
tc0 . y = dot4 ( vertex . position , rpTexGen0T ) ; 

tc0 . z = 0.0 ; 
tc0 . w = dot4 ( vertex . position , rpTexGen0Q ) ; 


result . texcoord0 . x = dot4 ( tc0 , rpTextureMatrixS ) ; 
result . texcoord0 . y = dot4 ( tc0 , rpTextureMatrixT ) ; 
result . texcoord0 . zw = tc0 . zw ; 


float4 vertexColor = ( swizzleColor ( vertex . color ) * rpVertexColorModulate ) + rpVertexColorAdd ; 
result . color = vertexColor * rpColor ; 
} 
