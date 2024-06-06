uniform float4 rpLocalLightOrigin : register(c4);
uniform float4 rpLocalViewOrigin : register(c5);
uniform float4 rpLightProjectionS : register(c6);
uniform float4 rpLightProjectionT : register(c7);
uniform float4 rpLightProjectionQ : register(c8);
uniform float4 rpLightFalloffS : register(c9);
uniform float4 rpBumpMatrixS : register(c10);
uniform float4 rpBumpMatrixT : register(c11);
uniform float4 rpDiffuseMatrixS : register(c12);
uniform float4 rpDiffuseMatrixT : register(c13);
uniform float4 rpSpecularMatrixS : register(c14);
uniform float4 rpSpecularMatrixT : register(c15);
uniform float4 rpVertexColorModulate : register(c16);
uniform float4 rpVertexColorAdd : register(c17);
uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpModelMatrixX : register(c25);
uniform float4 rpModelMatrixY : register(c26);
uniform float4 rpModelMatrixZ : register(c27);
uniform float4 rpModelMatrixW : register(c28);
uniform float4 rpModelViewMatrixX : register(c33);
uniform float4 rpModelViewMatrixY : register(c34);
uniform float4 rpModelViewMatrixZ : register(c35);
uniform float4 rpModelViewMatrixW : register(c36);
uniform float4 rpGlobalLightOrigin : register(c54);
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
float4 texcoord0 : TEXCOORD0 ; 
float4 texcoord1 : TEXCOORD1 ; 
float4 texcoord2 : TEXCOORD2 ; 
float4 texcoord3 : TEXCOORD3 ; 
float4 texcoord4 : TEXCOORD4 ; 
float4 texcoord5 : TEXCOORD5 ; 
float4 texcoord6 : TEXCOORD6 ; 
float4 texcoord7 : TEXCOORD7 ; 
float4 texcoord8 : TEXCOORD8 ; 
float4 texcoord9 : TEXCOORD9 ; 
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

float4 defaultTexCoord = float4 ( 0.0 , 0.5 , 0.0 , 1.0 ) ; 


float4 toLightLocal = rpLocalLightOrigin - modelPosition ; 




result . texcoord0 . x = dot3 ( tangent , toLightLocal ) ; 
result . texcoord0 . y = dot3 ( bitangent , toLightLocal ) ; 
result . texcoord0 . z = dot3 ( normal , toLightLocal ) ; 
result . texcoord0 . w = 1.0 ; 


result . texcoord1 = defaultTexCoord ; 
result . texcoord1 . x = dot4 ( vertex . texcoord . xy , rpBumpMatrixS ) ; 
result . texcoord1 . y = dot4 ( vertex . texcoord . xy , rpBumpMatrixT ) ; 


result . texcoord2 = defaultTexCoord ; 
result . texcoord2 . x = dot4 ( modelPosition , rpLightFalloffS ) ; 


result . texcoord3 . x = dot4 ( modelPosition , rpLightProjectionS ) ; 
result . texcoord3 . y = dot4 ( modelPosition , rpLightProjectionT ) ; 
result . texcoord3 . z = 0.0 ; 
result . texcoord3 . w = dot4 ( modelPosition , rpLightProjectionQ ) ; 


result . texcoord4 = defaultTexCoord ; 
result . texcoord4 . x = dot4 ( vertex . texcoord . xy , rpDiffuseMatrixS ) ; 
result . texcoord4 . y = dot4 ( vertex . texcoord . xy , rpDiffuseMatrixT ) ; 


result . texcoord5 = defaultTexCoord ; 
result . texcoord5 . x = dot4 ( vertex . texcoord . xy , rpSpecularMatrixS ) ; 
result . texcoord5 . y = dot4 ( vertex . texcoord . xy , rpSpecularMatrixT ) ; 




toLightLocal = normalize ( toLightLocal ) ; 


float4 toView = normalize ( rpLocalViewOrigin - modelPosition ) ; 


result . texcoord6 . x = dot3 ( tangent , toView ) ; 
result . texcoord6 . y = dot3 ( bitangent , toView ) ; 
result . texcoord6 . z = dot3 ( normal , toView ) ; 
result . texcoord6 . w = 1.0 ; 

result . texcoord7 = modelPosition ; 

float4 worldPosition ; 
worldPosition . x = dot4 ( modelPosition , rpModelMatrixX ) ; 
worldPosition . y = dot4 ( modelPosition , rpModelMatrixY ) ; 
worldPosition . z = dot4 ( modelPosition , rpModelMatrixZ ) ; 
worldPosition . w = dot4 ( modelPosition , rpModelMatrixW ) ; 

float4 toLightGlobal = rpGlobalLightOrigin - worldPosition ; 

result . texcoord8 = toLightGlobal ; 

float4 viewPosition ; 
viewPosition . x = dot4 ( modelPosition , rpModelViewMatrixX ) ; 
viewPosition . y = dot4 ( modelPosition , rpModelViewMatrixY ) ; 
viewPosition . z = dot4 ( modelPosition , rpModelViewMatrixZ ) ; 
viewPosition . w = dot4 ( modelPosition , rpModelViewMatrixW ) ; 

result . texcoord9 = viewPosition ; 




result . color = ( swizzleColor ( vertex . color ) * rpVertexColorModulate ) + rpVertexColorAdd ; 
} 
