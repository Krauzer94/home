uniform float4 rpScreenCorrectionFactor : register(c0);
void SMAAMovc (bool2 cond , inout float2 variable , float2 value )  {if ( cond . x ) variable . x = value . x ; if ( cond . y ) variable . y = value . y ; 
} 
void SMAAMovc (bool4 cond , inout float4 variable , float4 value )  {
SMAAMovc ( cond . xy , variable . xy , value . xy ) ; 
SMAAMovc ( cond . zw , variable . zw , value . zw ) ; 
} 
float4 SMAANeighborhoodBlendingPS (float2 texcoord , 
float4 offset , 
sampler2D colorTex , 
sampler2D blendTex 
)  {

float4 a ; 
a . x = texture ( blendTex , offset . xy ) . a ; 
a . y = texture ( blendTex , offset . zw ) . g ; 
a . wz = texture ( blendTex , texcoord ) . xz ; 
if ( dot ( a , float4 ( 1.0 , 1.0 , 1.0 , 1.0 ) ) < 1e-5 ) { 
float4 color = textureLod ( colorTex , texcoord , 0.0 ) ; 

return color ; 
} else { 
bool h = max ( a . x , a . z ) > max ( a . y , a . w ) ; 


float4 blendingOffset = float4 ( 0.0 , a . y , 0.0 , a . w ) ; 
float2 blendingWeight = a . yw ; 
SMAAMovc ( bool4 ( h , h , h , h ) , blendingOffset , float4 ( a . x , 0.0 , a . z , 0.0 ) ) ; 
SMAAMovc ( bool2 ( h , h ) , blendingWeight , a . xz ) ; 
blendingWeight /= dot ( blendingWeight , float2 ( 1.0 , 1.0 ) ) ; 


float4 blendingCoord = ( blendingOffset * float4 ( rpScreenCorrectionFactor . xy , - rpScreenCorrectionFactor . xy ) + texcoord . xyxy ) ; 



float4 color = blendingWeight . x * textureLod ( colorTex , blendingCoord . xy , 0.0 ) ; 
color += blendingWeight . y * textureLod ( colorTex , blendingCoord . zw , 0.0 ) ; 

return color ; 
} 
} 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float2 texcoord = fragment . texcoord0 ; 

float4 offset = fragment . texcoord1 ; 

float4 color = SMAANeighborhoodBlendingPS ( texcoord , 
offset , 
samp0 , 
samp1 
) ; 



result . color = color ; 
} 
