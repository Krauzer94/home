uniform float4 rpLocalViewOrigin : register(c5);
uniform float4 rpColor : register(c18);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
struct VS_IN {
float4 position : POSITION ; 
float4 normal : NORMAL ; 
float4 color : COLOR0 ; 
} ;
struct VS_OUT {
float4 position : POSITION ; 
float3 texcoord0 : TEXCOORD0 ; 
float3 texcoord1 : TEXCOORD1 ; 
float4 color : COLOR0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {

float4 vNormal = vertex . normal * 2.0 - 1.0 ; 

result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

float4 toEye = rpLocalViewOrigin - vertex . position ; 

result . texcoord0 = toEye . xyz ; 
result . texcoord1 = vNormal . xyz ; 

result . color = sRGBAToLinearRGBA ( rpColor ) ; 
} 
