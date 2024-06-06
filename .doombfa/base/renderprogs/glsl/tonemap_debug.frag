// filename renderprogs/tonemap.ps.hlsl
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


uniform vec4 _fa_[1];

const vec4 LUMINANCE_SRGB = vec4( 0.2125, 0.7154, 0.0721, 0.0 );
uniform sampler2D samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

vec3 ACESFilm (vec3 x ) {
	float a = 2.51 ;
	float b = 0.03 ;
	float c = 2.43 ;
	float d = 0.59 ;
	float e = 0.14 ;
	return saturate ( ( x * ( a * x + b ) ) / ( x * ( c * x + d ) + e ) ) ;
}
void main() {
	vec2 tCoords = vofi_TexCoord0 ;
	vec4 color = texture ( samp0 , tCoords ) ;
	float Y = dot ( LUMINANCE_SRGB , color ) ;
	float hdrGamma = 2.2 ;
	float gamma = hdrGamma ;
	float hdrKey = _fa_[0 /* rpScreenCorrectionFactor */] . x ;
	float hdrAverageLuminance = _fa_[0 /* rpScreenCorrectionFactor */] . y ;
	float hdrMaxLuminance = _fa_[0 /* rpScreenCorrectionFactor */] . z ;
	float Yr = ( hdrKey * Y ) / hdrAverageLuminance ;
	float Ymax = hdrMaxLuminance ;
	float avgLuminance = max ( hdrAverageLuminance , 0.001 ) ;
	float linearExposure = ( hdrKey / avgLuminance ) ;
	float exposure = log2 ( max ( linearExposure , 0.0001 ) ) ;
	vec3 exposedColor = exp2 ( exposure ) * color. rgb ;
	color. rgb = ACESFilm ( exposedColor ) ;
	gamma = 1.0 / hdrGamma ;
	color. r = pow ( color. r , gamma ) ;
	color. g = pow ( color. g , gamma ) ;
	color. b = pow ( color. b , gamma ) ;
	color = texture ( samp1 , vec2 ( dot ( LUMINANCE_SRGB , color ) , 0.0 ) ) ;
	fo_FragColor = color ;
}