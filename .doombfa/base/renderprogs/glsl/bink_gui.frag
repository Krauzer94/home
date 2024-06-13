// filename renderprogs/bink_gui.ps.hlsl
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

uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;

in vec2 vofi_TexCoord0;
in vec4 vofi_TexCoord1;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec3 crc = vec3 ( 1.595794678 , - 0.813476563 , 0 ) ;
	vec3 crb = vec3 ( 0 , - 0.391448975 , 2.017822266 ) ;
	vec3 adj = vec3 ( - 0.87065506 , 0.529705048 , - 1.081668854 ) ;
	vec3 YScalar = vec3 ( 1.164123535 , 1.164123535 , 1.164123535 ) ;
	float Y = texture ( samp0 , vofi_TexCoord0 . xy ). x ;
	float Cr = texture ( samp1 , vofi_TexCoord0 . xy ). x ;
	float Cb = texture ( samp2 , vofi_TexCoord0 . xy ). x ;
	vec3 p = ( YScalar * Y ) ;
	p += ( crc * Cr ) + ( crb * Cb ) + adj ;
	vec4 binkImage ;
	binkImage. xyz = p ;
	binkImage. w = 1.0 ;
	vec4 color = ( binkImage * vofi_Color ) + vofi_TexCoord1 ;
	fo_FragColor . xyz = color. xyz * color. w ;
	fo_FragColor . w = color. w ;
}