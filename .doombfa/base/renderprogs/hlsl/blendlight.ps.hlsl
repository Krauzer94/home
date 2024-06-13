uniform float4 rpColor : register(c18);
half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
half4 sRGBAToLinearRGBAUnclamped (half4 rgba )  {
return sRGBAToLinearRGBA ( rgba ) ; 
} 
static float4 idtex2Dproj (sampler2D samp , float4 texCoords )  {return tex2Dproj ( samp , texCoords . xyw ) ; } 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float4 position : WPOS ; 
float4 texcoord0 : TEXCOORD0_centroid ; 
float2 texcoord1 : TEXCOORD1_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
result . color = sRGBAToLinearRGBAUnclamped ( idtex2Dproj ( samp0 , fragment . texcoord0 ) * tex2D ( samp1 , fragment . texcoord1 ) * rpColor ) ; 
} 
