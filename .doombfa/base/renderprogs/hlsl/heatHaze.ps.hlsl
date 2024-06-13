uniform float4 rpWindowCoord : register(c1);
static float2 vposToScreenPosTexCoord (float2 vpos )  {return vpos . xy * rpWindowCoord . xy ; } 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float4 position : WPOS ; 
float4 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {


float4 bumpMap = ( tex2D ( samp1 , fragment . texcoord0 . xy ) * 2.0 ) - 1.0 ; 
float2 localNormal = bumpMap . wy ; 


float2 screenTexCoord = vposToScreenPosTexCoord ( fragment . position . xy ) ; 
screenTexCoord += ( localNormal * fragment . texcoord1 . xy ) ; 
screenTexCoord = saturate ( screenTexCoord ) ; 


result . color = ( tex2D ( samp0 , screenTexCoord . xy ) ) ; 
} 
