uniform float4 rpLocalLightOrigin : register(c4);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
uniform matrices_ubo {float4 matrices [ 408 ] ; } ;
struct VS_IN {
float4 position : POSITION ; 
float4 color : COLOR0 ; 
float4 color2 : COLOR1 ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {





const float w0 = vertex . color2 . x ; 
const float w1 = vertex . color2 . y ; 
const float w2 = vertex . color2 . z ; 
const float w3 = vertex . color2 . w ; 

float4 matX , matY , matZ ; 
int joint = int ( vertex . color . x * 255.1 * 3.0 ) ; 
matX = matrices [ int ( joint + 0 ) ] * w0 ; 
matY = matrices [ int ( joint + 1 ) ] * w0 ; 
matZ = matrices [ int ( joint + 2 ) ] * w0 ; 

joint = int ( vertex . color . y * 255.1 * 3.0 ) ; 
matX += matrices [ int ( joint + 0 ) ] * w1 ; 
matY += matrices [ int ( joint + 1 ) ] * w1 ; 
matZ += matrices [ int ( joint + 2 ) ] * w1 ; 

joint = int ( vertex . color . z * 255.1 * 3.0 ) ; 
matX += matrices [ int ( joint + 0 ) ] * w2 ; 
matY += matrices [ int ( joint + 1 ) ] * w2 ; 
matZ += matrices [ int ( joint + 2 ) ] * w2 ; 

joint = int ( vertex . color . w * 255.1 * 3.0 ) ; 
matX += matrices [ int ( joint + 0 ) ] * w3 ; 
matY += matrices [ int ( joint + 1 ) ] * w3 ; 
matZ += matrices [ int ( joint + 2 ) ] * w3 ; 

float4 vertexPosition = vertex . position ; 
vertexPosition . w = 1.0 ; 

float4 modelPosition ; 
modelPosition . x = dot4 ( matX , vertexPosition ) ; 
modelPosition . y = dot4 ( matY , vertexPosition ) ; 
modelPosition . z = dot4 ( matZ , vertexPosition ) ; 
modelPosition . w = vertex . position . w ; 

float4 vPos = modelPosition - rpLocalLightOrigin ; 
vPos = ( vPos . wwww * rpLocalLightOrigin ) + vPos ; 

result . position . x = dot4 ( vPos , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vPos , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vPos , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vPos , rpMVPmatrixW ) ; 
} 
