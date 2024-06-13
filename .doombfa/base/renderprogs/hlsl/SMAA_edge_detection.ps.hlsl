float2 SMAALumaEdgeDetectionPS (float2 texcoord , 
float4 offset [ 3 ] , 
sampler2D colorTex 
)  {
float2 threshold = float2 ( 0.1 , 0.1 ) ; 


float3 weights = float3 ( 0.2126 , 0.7152 , 0.0722 ) ; 
float L = dot ( texture ( colorTex , texcoord ) . rgb , weights ) ; 

float Lleft = dot ( texture ( colorTex , offset [ 0 ] . xy ) . rgb , weights ) ; 
float Ltop = dot ( texture ( colorTex , offset [ 0 ] . zw ) . rgb , weights ) ; 


float4 delta ; 
delta . xy = abs ( L - float2 ( Lleft , Ltop ) ) ; 
float2 edges = step ( threshold , delta . xy ) ; 


if ( dot ( edges , float2 ( 1.0 , 1.0 ) ) == 0.0 ) 
discard ; 


float Lright = dot ( texture ( colorTex , offset [ 1 ] . xy ) . rgb , weights ) ; 
float Lbottom = dot ( texture ( colorTex , offset [ 1 ] . zw ) . rgb , weights ) ; 
delta . zw = abs ( L - float2 ( Lright , Lbottom ) ) ; 


float2 maxDelta = max ( delta . xy , delta . zw ) ; 


float Lleftleft = dot ( texture ( colorTex , offset [ 2 ] . xy ) . rgb , weights ) ; 
float Ltoptop = dot ( texture ( colorTex , offset [ 2 ] . zw ) . rgb , weights ) ; 
delta . zw = abs ( float2 ( Lleft , Ltop ) - float2 ( Lleftleft , Ltoptop ) ) ; 


maxDelta = max ( maxDelta . xy , delta . zw ) ; 
float finalDelta = max ( maxDelta . x , maxDelta . y ) ; 


edges . xy *= step ( finalDelta , 2.0 * delta . xy ) ; 

return edges ; 
} 
uniform sampler2D samp0 : register(s0);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
float4 texcoord2 : TEXCOORD2_centroid ; 
float4 texcoord3 : TEXCOORD3_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float2 tCoords = fragment . texcoord0 ; 

float4 offset [ 3 ] ; 
offset [ 0 ] = fragment . texcoord1 ; 
offset [ 1 ] = fragment . texcoord2 ; 
offset [ 2 ] = fragment . texcoord3 ; 

float4 color = float4 ( 0.0 ) ; 
color . rg = SMAALumaEdgeDetectionPS ( tCoords , 
offset , 
samp0 
) ; 

result . color = color ; 
} 
