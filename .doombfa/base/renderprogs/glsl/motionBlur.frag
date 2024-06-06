// filename renderprogs/motionBlur.ps.hlsl
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

uniform sampler2D samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

void main() {
	if ( texture ( samp0 , vofi_TexCoord0 ). w == 0.0 ) {
		discard ;
	}
	float windowZ = texture ( samp1 , vofi_TexCoord0 ). x ;
	vec3 ndc = vec3 ( vofi_TexCoord0 * 2.0 - 1.0 , windowZ * 2.0 - 1.0 ) ;
	float clipW = - _fa_[4 /* rpProjectionMatrixZ */] . w / ( - _fa_[4 /* rpProjectionMatrixZ */] . z - ndc. z ) ;
	vec4 clip = vec4 ( ndc * clipW , clipW ) ;
	vec4 reClip ;
	reClip. x = dot ( _fa_[0 /* rpMVPmatrixX */] , clip ) ;
	reClip. y = dot ( _fa_[1 /* rpMVPmatrixY */] , clip ) ;
	reClip. z = dot ( _fa_[2 /* rpMVPmatrixZ */] , clip ) ;
	reClip. w = dot ( _fa_[3 /* rpMVPmatrixW */] , clip ) ;
	vec2 prevTexCoord ;
	prevTexCoord. x = ( reClip. x / reClip. w ) * 0.5 + 0.5 ;
	prevTexCoord. y = ( reClip. y / reClip. w ) * 0.5 + 0.5 ;
	vec2 texCoord = prevTexCoord ;
	vec2 delta = ( vofi_TexCoord0 - prevTexCoord ) ;
	vec3 sum = vec3 ( 0.0 ) ;
	float goodSamples = 0.0 ;
	float samples = _fa_[5 /* rpOverbright */] . x ;
	for ( float i = 0.0 ; i < samples ; i = i + 1.0 ) {
		vec2 pos = vofi_TexCoord0 + delta * ( ( i / ( samples - 1.0 ) ) - 0.5 ) ;
		vec4 color = texture ( samp0 , pos ) ;
		sum += color. xyz * color. w ;
		goodSamples += color. w ;
	}
	float invScale = 1.0 / goodSamples ;
	fo_FragColor = vec4 ( sum * invScale , 1.0 ) ;
}