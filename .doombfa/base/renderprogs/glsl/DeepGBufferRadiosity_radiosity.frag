// filename renderprogs/DeepGBufferRadiosity_radiosity.ps.hlsl
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
const float projScale = 500.0;
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

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
vec3 sampleNormal (sampler2D normalBuffer , ivec2 ssC , int mipLevel ) {
	return texelFetch ( normalBuffer , ssC , mipLevel ). xyz * 2.0 - 1.0 ;
}
vec2 tapLocation (int sampleNumber , float spinAngle , float radialJitter , out float ssR ) {
	float alpha = ( float ( sampleNumber ) + radialJitter ) * ( 1.0 / float ( 11 ) ) ;
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
void computeMipInfo (float ssR , ivec2 ssP , sampler2D cszBuffer , inout int mipLevel , inout ivec2 mipP ) {
	mipLevel = clamp ( int ( floor ( log2 ( ssR ) ) ) - ( 3 ) , 0 , ( 5 ) ) ;
	mipP = clamp ( ssP >> mipLevel , ivec2 ( 0 ) , textureSize ( cszBuffer , mipLevel ) - ivec2 ( 1 ) ) ;
}
void getOffsetPositionNormalAndLambertian (ivec2 ssP ,
float ssR ,
sampler2D cszBuffer ,
sampler2D bounceBuffer ,
sampler2D normalBuffer ,
inout vec3 Q ,
inout vec3 lambertian_tap ,
inout vec3 n_tap ) {
	int mipLevel ;
	ivec2 texel ;
	computeMipInfo ( ssR , ssP , cszBuffer , mipLevel , texel ) ;
	float z = texelFetch ( cszBuffer , texel , mipLevel ). r ;
	vec3 n = sampleNormal ( normalBuffer , ssP , 0 ) ;
	lambertian_tap = texelFetch ( bounceBuffer , ssP , 0 ). rgb ;
	n_tap = n ;
	Q = reconstructCSPosition ( ( vec2 ( ssP ) + vec2 ( 0.5 ) ) , z ) ;
}
void iiValueFromPositionsAndNormalsAndLambertian (ivec2 ssP , vec3 X , vec3 n_X , vec3 Y , vec3 n_Y , vec3 radiosity_Y , inout vec3 E , inout float weight_Y , inout float visibilityWeight_Y ) {
	vec3 YminusX = Y - X ;
	vec3 w_i = normalize ( YminusX ) ;
	weight_Y = ( ( dot ( w_i , n_X ) > 0.0 )
	&& ( dot ( - w_i , n_Y ) > 0.01 )
	) ? 1.0 : 0.0 ;
	if ( ( dot ( YminusX , YminusX ) < radius2 ) &&
	( weight_Y > 0.0 ) )
	{
		E = radiosity_Y * dot ( w_i , n_X ) ;
	}
	else
	{
		E = vec3 ( 0 ) ;
	}
}
void sampleIndirectLight (in ivec2 ssC ,
in vec3 C ,
in vec3 n_C ,
in vec3 C_peeled ,
in vec3 n_C_peeled ,
in float ssDiskRadius ,
in int tapIndex ,
in float randomPatternRotationAngle ,
in float radialJitter ,
in sampler2D cszBuffer ,
in sampler2D nBuffer ,
in sampler2D bounceBuffer ,
inout vec3 irradianceSum ,
inout float numSamplesUsed ,
inout vec3 iiPeeled ,
inout float weightSumPeeled ) {
	float visibilityWeightPeeled0 , visibilityWeightPeeled1 ;
	float ssR ;
	vec2 unitOffset = tapLocation ( tapIndex , randomPatternRotationAngle , radialJitter , ssR ) ;
	ssR *= ssDiskRadius ;
	ivec2 ssP = ivec2 ( ssR * unitOffset ) + ssC ;
	vec3 E ;
	float visibilityWeight ;
	float weight_Y ;
	vec3 Q , lambertian_tap , n_tap ;
	getOffsetPositionNormalAndLambertian ( ssP , ssR , cszBuffer , bounceBuffer , nBuffer , Q , lambertian_tap , n_tap ) ;
	iiValueFromPositionsAndNormalsAndLambertian ( ssP , C , n_C , Q , n_tap , lambertian_tap , E , weight_Y , visibilityWeight ) ;
	numSamplesUsed += weight_Y ;
	irradianceSum += E ;
}
void main() {
	fo_FragColor = vec4 ( 0.0 , 0.0 , 0.0 , 1.0 ) ;
	ivec2 ssC = ivec2 ( gl_FragCoord. xy ) ;
	vec3 C = getPosition ( ssC , samp1 ) ;
	vec3 C_peeled = vec3 ( 0 ) ;
	vec3 n_C_peeled = vec3 ( 0 ) ;
	vec3 n_C = sampleNormal ( samp0 , ssC , 0 ) ;
	float ssDiskRadius = - projScale * radius / C. z ;
	float randomPatternRotationAngle = float ( 3 * ssC. x ^ ssC. y + ssC. x * ssC. y ) * 10.0 ;
	float radialJitter = fract ( sin ( gl_FragCoord. x * 1e2 +
	gl_FragCoord. y ) * 1e5 + sin ( gl_FragCoord. y * 1e3 ) * 1e3 ) * 0.8 + 0.1 ;
	float numSamplesUsed = 0.0 ;
	vec3 irradianceSum = vec3 ( 0 ) ;
	vec3 ii_peeled = vec3 ( 0 ) ;
	float peeledSum = 0.0 ;
	for ( int i = 0 ; i < 11 ; ++ i )
	{
		sampleIndirectLight ( ssC , C , n_C , C_peeled , n_C_peeled , ssDiskRadius , i , randomPatternRotationAngle , radialJitter , samp1 , samp0 , samp2 , irradianceSum , numSamplesUsed , ii_peeled , peeledSum ) ;
	}
	float solidAngleHemisphere = 2.0 * 3.14159265358979323846 ;
	vec3 E_X = irradianceSum * solidAngleHemisphere / ( numSamplesUsed + 0.00001 ) ;
	fo_FragColor . rgb = E_X ;
	fo_FragColor . a = 1.0 - numSamplesUsed / float ( 11 ) ;
}