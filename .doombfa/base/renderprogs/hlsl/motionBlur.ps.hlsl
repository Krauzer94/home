uniform float4 rpMVPmatrixX : register(c21);
uniform float4 rpMVPmatrixY : register(c22);
uniform float4 rpMVPmatrixZ : register(c23);
uniform float4 rpMVPmatrixW : register(c24);
uniform float4 rpProjectionMatrixZ : register(c31);
uniform float4 rpOverbright : register(c50);
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

if ( tex2D ( samp0 , fragment . texcoord0 ) . w == 0.0 ) { 
discard ; 
} 


float windowZ = tex2D ( samp1 , fragment . texcoord0 ) . x ; 
float3 ndc = float3 ( fragment . texcoord0 * 2.0 - 1.0 , windowZ * 2.0 - 1.0 ) ; 
float clipW = - rpProjectionMatrixZ . w / ( - rpProjectionMatrixZ . z - ndc . z ) ; 

float4 clip = float4 ( ndc * clipW , clipW ) ; 


float4 reClip ; 
reClip . x = dot ( rpMVPmatrixX , clip ) ; 
reClip . y = dot ( rpMVPmatrixY , clip ) ; 
reClip . z = dot ( rpMVPmatrixZ , clip ) ; 
reClip . w = dot ( rpMVPmatrixW , clip ) ; 


float2 prevTexCoord ; 
prevTexCoord . x = ( reClip . x / reClip . w ) * 0.5 + 0.5 ; 
prevTexCoord . y = ( reClip . y / reClip . w ) * 0.5 + 0.5 ; 



float2 texCoord = prevTexCoord ; 
float2 delta = ( fragment . texcoord0 - prevTexCoord ) ; 

float3 sum = float3 ( 0.0 ) ; 
float goodSamples = 0.0 ; 
float samples = rpOverbright . x ; 

for ( float i = 0.0 ; i < samples ; i = i + 1.0 ) { 
float2 pos = fragment . texcoord0 + delta * ( ( i / ( samples - 1.0 ) ) - 0.5 ) ; 
float4 color = tex2D ( samp0 , pos ) ; 

sum += color . xyz * color . w ; 
goodSamples += color . w ; 
} 
float invScale = 1.0 / goodSamples ; 

result . color = float4 ( sum * invScale , 1.0 ) ; 
} 
