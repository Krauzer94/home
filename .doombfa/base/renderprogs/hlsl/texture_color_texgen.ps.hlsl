half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
static float4 idtex2Dproj (sampler2D samp , float4 texCoords )  {return tex2Dproj ( samp , texCoords . xyw ) ; } 
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float4 texcoord0 : TEXCOORD0_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {





float4 texSample = idtex2Dproj ( samp0 , fragment . texcoord0 ) ; 

result . color = sRGBAToLinearRGBA ( texSample ) * fragment . color ; 
} 
