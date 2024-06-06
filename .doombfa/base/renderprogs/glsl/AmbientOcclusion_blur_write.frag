// filename renderprogs/AmbientOcclusion_blur.ps.hlsl
#version 460
#pragma shader_stage( fragment )
#extension GL_ARB_separate_shader_objects : enable

void clip( float v ) { if ( v < 0.0 ) { discard; } }
void clip( vec2 v ) { if ( any( lessThan( v, vec2( 0.0 ) ) ) ) { discard; } }
void clip( vec3 v ) { if ( any( lessThan( v, vec3( 0.0 ) ) ) ) { discard; } }
void clip( vec4 v ) { if ( any( lessThan( v, vec4( 0.0 ) ) ) ) { discard; } }

float saturate( float v ) { return clamp( v, 0.0, 1.0 ); }
vec2 saturate( vec2 v ) { return clamp( v, 0.0, 1.0 ); }
vec3 saturate( vec3 v ) { return clamp( v, 0.0, 1.0 ); }
vec4 saturate( vec4 v ) { return clamp( v, 0.0, 1.0 ); }


uniform vec4 _fa_[6];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

vec3 sampleNormal (sampler2D normalBuffer , ivec2 ssC , int mipLevel ) {
	return normalize ( texelFetch ( normalBuffer , ssC , mipLevel ). xyz * 2.0 - 1.0 ) ;
}
const float FAR_PLANE_Z = -16000.0;
float CSZToKey (float z ) {
	return clamp ( z * ( 1.0 / FAR_PLANE_Z ) , 0.0 , 1.0 ) ;
}
vec3 reconstructCSPosition (vec2 S , float z ) {
	vec4 P ;
	P. z = z * 2.0 - 1.0 ;
	P. xy = ( S * _fa_[0 /* rpScreenCorrectionFactor */] . xy ) * 2.0 - 1.0 ;
	P. w = 1.0 ;
	vec4 csP ;
	csP. x = dot4 ( P , _fa_[1 /* rpModelMatrixX */] ) ;
	csP. y = dot4 ( P , _fa_[2 /* rpModelMatrixY */] ) ;
	csP. z = dot4 ( P , _fa_[3 /* rpModelMatrixZ */] ) ;
	csP. w = dot4 ( P , _fa_[4 /* rpModelMatrixW */] ) ;
	csP. xyz /= csP. w ;
	return csP. xyz ;
}
float getKey (ivec2 ssP ) {
	float key = texelFetch ( samp1 , ssP , 0 ). r ;
	vec3 P = reconstructCSPosition ( vec2 ( ssP ) + vec2 ( 0.5 ) , key ) ;
	key = P. z ;
	key = clamp ( key * ( 1.0 / FAR_PLANE_Z ) , 0.0 , 1.0 ) ;
	return key ;
}
vec3 getPosition (ivec2 ssP , sampler2D samp1 ) {
	vec3 P ;
	P. z = texelFetch ( samp1 , ssP , 0 ). r ;
	P = reconstructCSPosition ( vec2 ( ssP ) + vec2 ( 0.5 ) , P. z ) ;
	return P ;
}
float calculateBilateralWeight (float key , float tapKey , ivec2 tapLoc , vec3 n_C , vec3 C ) {
	float depthWeight = max ( 0.0 , 1.0 - ( ( 1.0 ) * 2000.0 ) * abs ( tapKey - key ) ) ;
	float k_normal = 1.0 ;
	float k_plane = 1.0 ;
	float normalWeight = 1.0 ;
	float planeWeight = 1.0 ;
	vec3 tapN_C = sampleNormal ( samp0 , tapLoc , 0 ) ;
	depthWeight = 1.0 ;
	float normalError = 1.0 - dot ( tapN_C , n_C ) * k_normal ;
	normalWeight = max ( ( 1.0 - ( 1.0 ) * normalError ) , 0.00 ) ;
	float lowDistanceThreshold2 = 0.001 ;
	vec3 tapC = getPosition ( tapLoc , samp1 ) ;
	vec3 dq = C - tapC ;
	float distance2 = dot ( dq , dq ) ;
	float planeError = max ( abs ( dot ( dq , tapN_C ) ) , abs ( dot ( dq , n_C ) ) ) ;
	planeWeight = ( distance2 < lowDistanceThreshold2 ) ? 1.0 :
	pow ( max ( 0.0 , 1.0 - ( 1.0 ) * 2.0 * k_plane * planeError / sqrt ( distance2 ) ) , 2.0 ) ;
	return depthWeight * normalWeight * planeWeight ;
}
void main() {
	float kernel [ ( 4 ) + 1 ] ;
	kernel [ 0 ] = 0.153170 ;
	kernel [ 1 ] = 0.144893 ;
	kernel [ 2 ] = 0.122649 ;
	kernel [ 3 ] = 0.092902 ;
	kernel [ 4 ] = 0.062970 ;
	ivec2 ssC = ivec2 ( gl_FragCoord. xy ) ;
	vec4 temp = texelFetch ( samp2 , ssC , 0 ) ;
	vec3 C = getPosition ( ssC , samp1 ) ;
	float key = CSZToKey ( C. z ) ;
	float sum = temp. r ;
	if ( key == 1.0 )
	{
		fo_FragColor . r = sum ;
		fo_FragColor = vec4 ( fo_FragColor . r , fo_FragColor . r , fo_FragColor . r , 1.0 ) ;
		return ;
	}
	float BASE = kernel [ 0 ] ;
	float totalWeight = BASE ;
	sum *= totalWeight ;
	vec3 n_C ;
	n_C = sampleNormal ( samp0 , ssC , 0 ) ;
	for ( int r = - ( 4 ) ; r <= ( 4 ) ; ++ r )
	{
		if ( r != 0 )
		{
			ivec2 tapLoc = ssC + ivec2 ( _fa_[5 /* rpJitterTexScale */] . xy ) * ( r * ( 2 ) ) ;
			temp = texelFetch ( samp2 , tapLoc , 0 ) ;
			float tapKey = getKey ( tapLoc ) ;
			float value = temp. r ;
			float weight = 0.3 + kernel [ abs ( r ) ] ;
			float bilateralWeight = calculateBilateralWeight ( key , tapKey , tapLoc , n_C , C ) ;
			weight *= bilateralWeight ;
			sum += value * weight ;
			totalWeight += weight ;
		}
	}
	float epsilon = 0.0001 ;
	fo_FragColor . r = sum / ( totalWeight + epsilon ) ;
	fo_FragColor = vec4 ( fo_FragColor . r , fo_FragColor . r , fo_FragColor . r , 1.0 ) ;
}