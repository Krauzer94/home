// filename renderprogs/bloodorb3_capture.ps.hlsl
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
in vec2 vofi_TexCoord3;
in vec2 vofi_TexCoord4;

out vec4 fo_FragColor;

void main() {
	float colorFactor = vofi_TexCoord4 . x ;
	vec4 color0 = vec4 ( 1.0 - colorFactor , 1.0 - colorFactor , 1.0 , 1.0 ) ;
	vec4 color1 = vec4 ( 1.0 , 0.95 - colorFactor , 0.95 , 0.5 ) ;
	vec4 color2 = vec4 ( 0.015 , 0.015 , 0.015 , 0.01 ) ;
	vec4 accumSample0 = texture ( samp0 , vofi_TexCoord0 ) * color0 ;
	vec4 accumSample1 = texture ( samp0 , vofi_TexCoord1 ) * color1 ;
	vec4 accumSample2 = texture ( samp0 , vofi_TexCoord2 ) * color2 ;
	vec4 maskSample = texture ( samp2 , vofi_TexCoord3 ) ;
	vec4 tint = vec4 ( 0.8 , 0.5 , 0.5 , 1 ) ;
	vec4 currentRenderSample = texture ( samp1 , vofi_TexCoord3 ) * tint ;
	vec4 accumColor = mix ( accumSample0 , accumSample1 , 0.5 ) ;
	accumColor += accumSample2 ;
	accumColor = mix ( accumColor , currentRenderSample , maskSample. a ) ;
	fo_FragColor = accumColor ;
}