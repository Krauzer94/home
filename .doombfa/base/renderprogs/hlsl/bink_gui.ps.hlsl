uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
const float3 crc = float3 ( 1.595794678 , - 0.813476563 , 0 ) ; 
const float3 crb = float3 ( 0 , - 0.391448975 , 2.017822266 ) ; 
const float3 adj = float3 ( - 0.87065506 , 0.529705048 , - 1.081668854 ) ; 
const float3 YScalar = float3 ( 1.164123535 , 1.164123535 , 1.164123535 ) ; 

float Y = tex2D ( samp0 , fragment . texcoord0 . xy ) . x ; 
float Cr = tex2D ( samp1 , fragment . texcoord0 . xy ) . x ; 
float Cb = tex2D ( samp2 , fragment . texcoord0 . xy ) . x ; 

float3 p = ( YScalar * Y ) ; 
p += ( crc * Cr ) + ( crb * Cb ) + adj ; 

float4 binkImage ; 
binkImage . xyz = p ; 
binkImage . w = 1.0 ; 

float4 color = ( binkImage * fragment . color ) + fragment . texcoord1 ; 
result . color . xyz = color . xyz * color . w ; 
result . color . w = color . w ; 
} 
