uniform float4 rpWindowCoord : register(c1);
static float2 vposToScreenPosTexCoord (float2 vpos )  {return vpos . xy * rpWindowCoord . xy ; } 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
struct PS_IN {
float4 position : WPOS ; 
float4 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
float4 texcoord2 : TEXCOORD2_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {


float4 mask = tex2D ( samp2 , fragment . texcoord0 . xy ) ; 


mask . xy -= 0.01 ; 
clip ( mask ) ; 


float4 bumpMap = ( tex2D ( samp1 , fragment . texcoord1 . xy ) * 2.0 ) - 1.0 ; 
float2 localNormal = bumpMap . wy ; 
localNormal *= mask . xy ; 


float2 screenTexCoord = vposToScreenPosTexCoord ( fragment . position . xy ) ; 
screenTexCoord += ( localNormal * fragment . texcoord2 . xy ) ; 
screenTexCoord = saturate ( screenTexCoord ) ; 

result . color = ( tex2D ( samp0 , screenTexCoord ) ) ; 
} 
