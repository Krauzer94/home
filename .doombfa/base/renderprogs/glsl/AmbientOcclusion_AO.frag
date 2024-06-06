// filename renderprogs/AmbientOcclusion_AO.ps.hlsl
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


uniform vec4 _fa_[5];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
const float DOOM_TO_METERS = 0.0254;
const float METERS_TO_DOOM = ( 1.0 / DOOM_TO_METERS );
const float radius = 1.0 * METERS_TO_DOOM;
const float radius2 = radius * radius;
const float invRadius2 = 1.0 / radius2;
const float bias = 0.01 * METERS_TO_DOOM;
const float intensity = 0.6;
const float projScale = 500.0;
uniform sampler2D samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

vec3 reconstructCSPosition (vec2 S , float z ) {
	vec4 P ;
	P = vec4 ( S * _fa_[0 /* rpScreenCorrectionFactor */] . xy , z , 1.0 ) * 4.0 - 1.0 ;
	vec4 csP ;
	csP. x = dot4 ( P , _fa_[1 /* rpModelMatrixX */] ) ;
	csP. y = dot4 ( P , _fa_[2 /* rpModelMatrixY */] ) ;
	csP. z = dot4 ( P , _fa_[3 /* rpModelMatrixZ */] ) ;
	csP. w = dot4 ( P , _fa_[4 /* rpModelMatrixW */] ) ;
	csP. xyz /= csP. w ;
	return ( csP. xyz * 0.5 ) + 0.5 ;
}
vec3 sampleNormal (sampler2D normalBuffer , ivec2 ssC , int mipLevel ) {
	return texelFetch ( normalBuffer , ssC , mipLevel ). xyz * 2.0 - 1.0 ;
}
vec2 tapLocation (int sampleNumber , float spinAngle , out float ssR ) {
	float alpha = ( float ( sampleNumber ) + 0.5 ) * ( 1.0 / float ( 11 ) ) ;
	float angle = alpha * ( float ( 7 ) * 6.28 ) + spinAngle ;
	ssR = alpha ;
	return vec2 ( cos ( angle ) , sin ( angle ) ) ;
}
vec3 getPosition (ivec2 ssP , sampler2D cszBuffer ) {
	vec3 P ;
	P. z = texelFetch ( cszBuffer , ssP , 0 ). r ;
	P = reconstructCSPosition ( vec2 ( ssP ) + vec2 ( 0.5 ) , P. z ) ;
	return P ;
}
void computeMipInfo (float ssR , ivec2 ssP , sampler2D cszBuffer , out int mipLevel , out ivec2 mipP ) {
	mipLevel = clamp ( int ( floor ( log2 ( ssR ) ) ) - ( 3 ) , 0 , ( 5 ) ) ;
	mipP = clamp ( ssP >> mipLevel , ivec2 ( 0 ) , textureSize ( cszBuffer , mipLevel ) - ivec2 ( 1 ) ) ;
}
vec3 getOffsetPosition (ivec2 issC , vec2 unitOffset , float ssR , sampler2D cszBuffer , float invCszBufferScale ) {
	ivec2 ssP = ivec2 ( ssR * unitOffset ) + issC ;
	vec3 P ;
	int mipLevel ;
	ivec2 mipP ;
	computeMipInfo ( ssR , ssP , cszBuffer , mipLevel , mipP ) ;
	P. z = texelFetch ( cszBuffer , mipP , mipLevel ). r ;
	P = reconstructCSPosition ( vec2 ( ssP ) + vec2 ( 0.5 ) , P. z ) ;
	return P ;
}
float fallOffFunction (float vv , float vn , float epsilon ) {
	float f = max ( 1.0 - vv * invRadius2 , 0.0 ) ;
	return f * max ( ( vn - bias ) * inversesqrt ( epsilon + vv ) , 0.0 ) ;
}
float aoValueFromPositionsAndNormal (vec3 C , vec3 n_C , vec3 Q ) {
	vec3 v = Q - C ;
	float vv = dot ( v , v ) ;
	float vn = dot ( v , n_C ) ;
	const float epsilon = 0.001 ;
	return fallOffFunction ( vv , vn , epsilon ) * mix ( 1.0 , max ( 0.0 , 1.5 * n_C. z ) , 0.35 ) ;
}
float sampleAO (ivec2 issC , in vec3 C , in vec3 n_C , in float ssDiskRadius , in int tapIndex , in float randomPatternRotationAngle , in sampler2D cszBuffer , in float invCszBufferScale ) {
	float ssR ;
	vec2 unitOffset = tapLocation ( tapIndex , randomPatternRotationAngle , ssR ) ;
	ssR = max ( 0.75 , ssR * ssDiskRadius ) ;
	vec3 Q = getOffsetPosition ( issC , unitOffset , ssR , cszBuffer , invCszBufferScale ) ;
	return aoValueFromPositionsAndNormal ( C , n_C , Q ) ;
}
const float MIN_RADIUS = 3.0;
void main() {
	fo_FragColor = vec4 ( 1.0 , 0.0 , 0.0 , 1.0 ) ;
	ivec2 ssP = ivec2 ( gl_FragCoord. xy ) ;
	vec3 C = getPosition ( ssP , samp1 ) ;
	fo_FragColor . r = 0.0 ;
	vec3 n_C = sampleNormal ( samp0 , ssP , 0 ) ;
	if ( length ( n_C ) < 0.01 )
	{
		fo_FragColor . r = 1.0 ;
		return ;
	}
	n_C = normalize ( n_C ) ;
	float randomPatternRotationAngle = float ( ( ( 3 * ssP. x ) ^ ( ssP. y + ssP. x * ssP. y ) )
	) * 10.0 ;
	float ssDiskRadius = - projScale * radius / C. z ;
	if ( ssDiskRadius <= MIN_RADIUS )
	{
		fo_FragColor . r = 1.0 ;
		return ;
	}
	float sum = 0.0 ;
	for ( int i = 0 ; i < 11 ; ++ i )
	{
		sum += sampleAO ( ssP , C , n_C , ssDiskRadius , i , randomPatternRotationAngle , samp1 , 1.0 ) ;
	}
	float A = pow ( max ( 0.0 , 1.0 - sqrt ( sum * ( 3.0 / float ( 11 ) ) ) ) , intensity ) ;
	fo_FragColor . r = mix ( 1.0 , A , saturate ( ssDiskRadius - MIN_RADIUS ) ) ;
}