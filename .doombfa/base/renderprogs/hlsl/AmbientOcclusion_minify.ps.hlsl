uniform float4 rpScreenCorrectionFactor : register(c0);
uniform float4 rpJitterTexScale : register(c55);
uniform sampler2D samp0 : register( s0 );
struct PS_IN {
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {

int2 ssP = int2 ( fragment . texcoord0 * rpScreenCorrectionFactor . zw ) ; 

int previousMIPNumber = int ( rpJitterTexScale . x ) ; 




result . color . r = texelFetch ( samp0 , clamp ( ssP * 2 + int2 ( ssP . y & 1 , ssP . x & 1 ) , int2 ( 0 ) , textureSize ( samp0 , previousMIPNumber ) - int2 ( 1 ) ) , previousMIPNumber ) . r ; 
} 
