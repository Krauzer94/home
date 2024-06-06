// filename renderprogs/postprocess.ps.hlsl
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


uniform vec4 _fa_[2];

const vec4 LUMINANCE_SRGB = vec4( 0.2125, 0.7154, 0.0721, 0.0 );
uniform sampler2D samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

vec3 overlay (vec3 a , vec3 b ) {
	return vec3 (
	b. x < 0.5 ? ( 2.0 * a. x * b. x ) : ( 1.0 - 2.0 * ( 1.0 - a. x ) * ( 1.0 - b. x ) ) ,
	b. y < 0.5 ? ( 2.0 * a. y * b. y ) : ( 1.0 - 2.0 * ( 1.0 - a. y ) * ( 1.0 - b. y ) ) ,
	b. z < 0.5 ? ( 2.0 * a. z * b. z ) : ( 1.0 - 2.0 * ( 1.0 - a. z ) * ( 1.0 - b. z ) ) ) ;
}
void TechnicolorPass (inout vec4 color ) {
	const vec3 cyanFilter = vec3 ( 0.0 , 1.30 , 1.0 ) ;
	const vec3 magentaFilter = vec3 ( 1.0 , 0.0 , 1.05 ) ;
	const vec3 yellowFilter = vec3 ( 1.6 , 1.6 , 0.05 ) ;
	const vec3 redOrangeFilter = vec3 ( 1.05 , 0.62 , 0.0 ) ;
	const vec3 greenFilter = vec3 ( 0.3 , 1.0 , 0.0 ) ;
	vec2 redNegativeMul = color. rg * ( 1.0 / ( 0.88 * 4.0 ) ) ;
	vec2 greenNegativeMul = color. rg * ( 1.0 / ( 0.88 * 4.0 ) ) ;
	vec2 blueNegativeMul = color. rb * ( 1.0 / ( 0.88 * 4.0 ) ) ;
	float redNegative = dot ( redOrangeFilter. rg , redNegativeMul ) ;
	float greenNegative = dot ( greenFilter. rg , greenNegativeMul ) ;
	float blueNegative = dot ( magentaFilter. rb , blueNegativeMul ) ;
	vec3 redOutput = vec3 ( redNegative ) + cyanFilter ;
	vec3 greenOutput = vec3 ( greenNegative ) + magentaFilter ;
	vec3 blueOutput = vec3 ( blueNegative ) + yellowFilter ;
	vec3 result = redOutput * greenOutput * blueOutput ;
	color. rgb = mix ( color. rgb , result , 0.5 ) ;
}
void VibrancePass (inout vec4 color ) {
	const vec3 vibrance = vec3 ( 1.0 , 1.0 , 1.0 ) * 0.5 ;
	float Y = dot ( LUMINANCE_SRGB , color ) ;
	float minColor = min ( color. r , min ( color. g , color. b ) ) ;
	float maxColor = max ( color. r , max ( color. g , color. b ) ) ;
	float colorSat = maxColor - minColor ;
	color. rgb = mix ( vec3 ( Y ) , color. rgb , ( 1.0 + ( vibrance * ( 1.0 - ( sign ( vibrance ) * colorSat ) ) ) ) ) ;
}
void FilmgrainPass (inout vec4 color ) {
	vec4 jitterTC = ( gl_FragCoord * _fa_[0 /* rpScreenCorrectionFactor */] ) + _fa_[1 /* rpJitterTexOffset */] ;
	vec4 noiseColor = texture ( samp1 , gl_FragCoord . xy + jitterTC. xy ) ;
	float Y = noiseColor. r ;
	float exposureFactor = 1.0 ;
	exposureFactor = sqrt ( exposureFactor ) ;
	const float noiseIntensity = 1.7 ;
	float t = mix ( 3.5 * noiseIntensity , 1.13 * noiseIntensity , exposureFactor ) ;
	color. rgb = overlay ( color. rgb , mix ( vec3 ( 0.5 ) , noiseColor. rgb , t ) ) ;
}
void main() {
	vec2 tCoords = vofi_TexCoord0 ;
	vec4 color = texture ( samp0 , tCoords ) ;
	TechnicolorPass ( color ) ;
	VibrancePass ( color ) ;
	FilmgrainPass ( color ) ;
	fo_FragColor = color ;
}