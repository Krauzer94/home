// filename renderprogs/bloodorb2_capture.ps.hlsl
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
in vec2 vofi_TexCoord1;
in vec2 vofi_TexCoord2;

out vec4 fo_FragColor;

void main() {
	vec4 redTint = vec4 ( 1 , 0.98 , 0.98 , 1 ) ;
	vec4 accumSample = texture ( samp0 , vofi_TexCoord0 ) * redTint ;
	vec4 maskSample = texture ( samp2 , vofi_TexCoord1 ) ;
	vec4 tint = vec4 ( 1.0 , 0.8 , 0.8 , 1 ) ;
	vec4 currentRenderSample = texture ( samp1 , vofi_TexCoord2 ) * tint ;
	fo_FragColor = mix ( accumSample , currentRenderSample , maskSample. a ) ;
}