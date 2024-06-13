uniform float4 rpLocalLightOrigin : register(c4);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
struct VS_IN {
float4 position : POSITION ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {
float4 vPos = vertex . position - rpLocalLightOrigin ; 
vPos = ( vPos . wwww * rpLocalLightOrigin ) + vPos ; 

result . position . x = dot4 ( vPos , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vPos , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vPos , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vPos , rpMVPmatrixW ) ; 
} 
