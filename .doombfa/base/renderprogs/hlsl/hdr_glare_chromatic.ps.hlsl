uniform float4 rpWindowCoord : register(c1);
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float2 st = fragment . texcoord0 ; 


float4 color = tex2D ( samp0 , st ) ; 

const float gaussFact [ 9 ] = float [ 9 ] ( 0.13298076 , 0.12579441 , 0.10648267 , 0.08065691 , 0.05467002 , 0.03315905 , 0.01799699 , 0.00874063 , 0.00379866 ) ; 

const float3 chromaticOffsets [ 9 ] = float3 [ ] ( 
float3 ( 0.5 , 0.5 , 0.5 ) , 
float3 ( 0.8 , 0.3 , 0.3 ) , 

float3 ( 0.5 , 0.2 , 0.8 ) , 
float3 ( 0.2 , 0.2 , 1.0 ) , 
float3 ( 0.2 , 0.3 , 0.9 ) , 
float3 ( 0.2 , 0.9 , 0.2 ) , 
float3 ( 0.3 , 0.5 , 0.3 ) , 
float3 ( 0.3 , 0.5 , 0.3 ) , 
float3 ( 0.3 , 0.5 , 0.3 ) 

) ; 

float3 sumColor = float3 ( 0.0 ) ; 
float3 sumSpectrum = float3 ( 0.0 ) ; 

const int tap = 4 ; 
const int samples = 9 ; 

float scale = 13.0 ; 
const float weightScale = 1.9 ; 

for ( int i = 0 ; i < samples ; i ++ ) 
{ 





float3 so = chromaticOffsets [ i ] ; 
float4 color = tex2D ( samp0 , st + float2 ( float ( i ) , 0 ) * rpWindowCoord . xy * scale ) ; 

float weight = gaussFact [ i ] ; 
sumColor += color . rgb * ( so . rgb * weight * weightScale ) ; 
} 
for ( int i = 1 ; i < samples ; i ++ ) 
{ 



float3 so = chromaticOffsets [ i ] ; 
float4 color = tex2D ( samp0 , st + float2 ( float ( - i ) , 0 ) * rpWindowCoord . xy * scale ) ; 

float weight = gaussFact [ i ] ; 
sumColor += color . rgb * ( so . rgb * weight * weightScale ) ; 
} 

result . color = float4 ( sumColor , 1.0 ) ; 


} 
