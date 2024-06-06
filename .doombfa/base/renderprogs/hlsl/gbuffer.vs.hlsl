uniform float4 rpBumpMatrixS : register(c10);
uniform float4 rpBumpMatrixT : register(c11);
uniform float4 rpVertexColorModulate : register(c16);
uniform float4 rpVertexColorAdd : register(c17);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpModelViewMatrixX : register(c33);
uniform float4 rpModelViewMatrixY : register(c34);
uniform float4 rpModelViewMatrixZ : register(c35);
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
float4 color2 : COLOR1 ; 
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

float4 vNormal = vertex . normal * 2.0 - 1.0 ; 
float4 vTangent = vertex . tangent * 2.0 - 1.0 ; 
float3 vBitangent = cross ( vNormal . xyz , vTangent . xyz ) * vTangent . w ; 
float4 modelPosition = vertex . position ; 
float3 normal = vNormal . xyz ; 
float3 tangent = vTangent . xyz ; 
float3 bitangent = vBitangent . xyz ; 

result . position . x = dot4 ( modelPosition , rpMVPmatrixX ) ; 
result . position . y = dot4 ( modelPosition , rpMVPmatrixY ) ; 
result . position . z = dot4 ( modelPosition , rpMVPmatrixZ ) ; 
result . position . w = dot4 ( modelPosition , rpMVPmatrixW ) ; 


result . texcoord0 . x = dot4 ( vertex . texcoord . xy , rpBumpMatrixS ) ; 
result . texcoord0 . y = dot4 ( vertex . texcoord . xy , rpBumpMatrixT ) ; 

result . texcoord2 . x = dot3 ( tangent , rpModelViewMatrixX ) ; 
result . texcoord3 . x = dot3 ( tangent , rpModelViewMatrixY ) ; 
result . texcoord4 . x = dot3 ( tangent , rpModelViewMatrixZ ) ; 

result . texcoord2 . y = dot3 ( bitangent , rpModelViewMatrixX ) ; 
result . texcoord3 . y = dot3 ( bitangent , rpModelViewMatrixY ) ; 
result . texcoord4 . y = dot3 ( bitangent , rpModelViewMatrixZ ) ; 

result . texcoord2 . z = dot3 ( normal , rpModelViewMatrixX ) ; 
result . texcoord3 . z = dot3 ( normal , rpModelViewMatrixY ) ; 
result . texcoord4 . z = dot3 ( normal , rpModelViewMatrixZ ) ; 




result . color = ( swizzleColor ( vertex . color ) * rpVertexColorModulate ) + rpVertexColorAdd ; 
} 
