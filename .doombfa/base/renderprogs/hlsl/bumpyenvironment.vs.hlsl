uniform float4 rpLocalViewOrigin : register(c5);
uniform float4 rpColor : register(c18);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpModelMatrixX : register(c25);
uniform float4 rpModelMatrixY : register(c26);
uniform float4 rpModelMatrixZ : register(c27);
static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
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
float3 texcoord1 : TEXCOORD1 ; 
float3 texcoord2 : TEXCOORD2 ; 
float3 texcoord3 : TEXCOORD3 ; 
float3 texcoord4 : TEXCOORD4 ; 
float4 color : COLOR0 ; 
} ;
void main (VS_IN vertex , out VS_OUT result )  {

float4 normal = vertex . normal * 2.0 - 1.0 ; 
float4 tangent = vertex . tangent * 2.0 - 1.0 ; 
float3 binormal = cross ( normal . xyz , tangent . xyz ) * tangent . w ; 

result . position . x = dot4 ( vertex . position , rpMVPmatrixX ) ; 
result . position . y = dot4 ( vertex . position , rpMVPmatrixY ) ; 
result . position . z = dot4 ( vertex . position , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( vertex . position , rpMVPmatrixW ) ; 

result . texcoord0 = vertex . texcoord . xy ; 

float4 toEye = rpLocalViewOrigin - vertex . position ; 
result . texcoord1 . x = dot3 ( toEye , rpModelMatrixX ) ; 
result . texcoord1 . y = dot3 ( toEye , rpModelMatrixY ) ; 
result . texcoord1 . z = dot3 ( toEye , rpModelMatrixZ ) ; 

result . texcoord2 . x = dot3 ( tangent , rpModelMatrixX ) ; 
result . texcoord3 . x = dot3 ( tangent , rpModelMatrixY ) ; 
result . texcoord4 . x = dot3 ( tangent , rpModelMatrixZ ) ; 

result . texcoord2 . y = dot3 ( binormal , rpModelMatrixX ) ; 
result . texcoord3 . y = dot3 ( binormal , rpModelMatrixY ) ; 
result . texcoord4 . y = dot3 ( binormal , rpModelMatrixZ ) ; 

result . texcoord2 . z = dot3 ( normal , rpModelMatrixX ) ; 
result . texcoord3 . z = dot3 ( normal , rpModelMatrixY ) ; 
result . texcoord4 . z = dot3 ( normal , rpModelMatrixZ ) ; 

result . color = rpColor ; 
} 
