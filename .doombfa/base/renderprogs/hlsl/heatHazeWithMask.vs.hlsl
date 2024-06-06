uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpProjectionMatrixY : register(c30);
uniform float4 rpProjectionMatrixW : register(c32);
uniform float4 rpModelViewMatrixZ : register(c35);
uniform float4 rpEnableSkinning : register(c51);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
uniform matrices_ubo {float4 matrices [ 408 ] ; } ;
uniform float4 rpUser0 : register(c128);
uniform float4 rpUser1 : register(c129);
struct VS_IN {
float4 position : POSITION ; 
float2 texcoord : TEXCOORD0 ; 
float4 normal : NORMAL ; 
float4 tangent : TANGENT ; 
float4 color : COLOR0 ; 
float4 color2 : COLOR1 ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
float4 texcoord0 : TEXCOORD0 ; 
float4 texcoord1 : TEXCOORD1 ; 
float4 texcoord2 : TEXCOORD2 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {



























float4 modelPosition = vertex . position ; if ( rpEnableSkinning . x > 0.0 ) { 





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

modelPosition . x = dot4 ( matX , vertex . position ) ; 
modelPosition . y = dot4 ( matY , vertex . position ) ; 
modelPosition . z = dot4 ( matZ , vertex . position ) ; 
modelPosition . w = 1.0 ; 
} 


result . position . x = dot4 ( modelPosition , rpMVPmatrixX ) ; 
result . position . y = dot4 ( modelPosition , rpMVPmatrixY ) ; 
result . position . z = dot4 ( modelPosition , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( modelPosition , rpMVPmatrixW ) ; 



result . texcoord0 = float4 ( vertex . texcoord . xy , 0 , 0 ) ; 


const float4 textureScroll = rpUser0 ; 
result . texcoord1 = float4 ( vertex . texcoord . xy , 0 , 0 ) + textureScroll ; 


float4 vec = float4 ( 0 , 1 , 0 , 1 ) ; 
vec . z = dot4 ( modelPosition , rpModelViewMatrixZ ) ; 




const float magicProjectionAdjust = 0.43 ; 
float x = dot4 ( vec , rpProjectionMatrixY ) * magicProjectionAdjust ; 
float w = dot4 ( vec , rpProjectionMatrixW ) ; 


w = max ( w , 1.0 ) ; 
x /= w ; 



x = min ( x , 0.02 ) ; 

const float4 deformMagnitude = rpUser1 ; 
result . texcoord2 = x * deformMagnitude ; 
} 
