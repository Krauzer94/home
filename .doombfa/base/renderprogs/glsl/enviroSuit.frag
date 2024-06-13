// filename renderprogs/enviroSuit.ps.hlsl
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

in vec2 vofi_TexCoord0;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec2 screenTexCoord = vofi_TexCoord0 ;
	vec4 warpFactor = 1.0 - ( texture ( samp1 , screenTexCoord. xy ) * vofi_Color ) ;
	screenTexCoord -= vec2 ( 0.5 , 0.5 ) ;
	screenTexCoord *= warpFactor. xy ;
	screenTexCoord += vec2 ( 0.5 , 0.5 ) ;
	fo_FragColor = texture ( samp0 , screenTexCoord ) ;
}