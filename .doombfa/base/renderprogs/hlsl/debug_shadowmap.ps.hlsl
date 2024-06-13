uniform float4 rpScreenCorrectionFactor : register(c0);
uniform sampler2DArray samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float3 tc ; 
tc . xy = fragment . texcoord0 . xy ; 
tc . z = rpScreenCorrectionFactor . x ; 

result . color = texture ( samp0 , tc ) ; 
} 
