uniform sampler2D samp0 : register(s0);
struct PS_IN {
vec4 texcoord0 : TEXCOORD0_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
const float screenWarp_range = 1.45 ; 

const vec2 warpCenter = vec2 ( 0.5 , 0.5 ) ; 
vec2 centeredTexcoord = fragment . texcoord0 . xy - warpCenter ; 

float radialLength = length ( centeredTexcoord ) ; 
vec2 radialDir = normalize ( centeredTexcoord ) ; 


float range = screenWarp_range ; 
float scaledRadialLength = radialLength * range ; 
float tanScaled = tan ( scaledRadialLength ) ; 

float rescaleValue = tan ( 0.5 * range ) ; 




float rescaled = tanScaled / rescaleValue ; 

vec2 warped = warpCenter + vec2 ( 0.5 , 0.5 ) * radialDir * rescaled ; 

result . color = tex2D ( samp0 , warped ) ; 
} 
