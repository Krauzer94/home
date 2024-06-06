// filename renderprogs/stereoWarp.ps.hlsl
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

in vec4 vofi_TexCoord0;

out vec4 fo_FragColor;

void main() {
	float screenWarp_range = 1.45 ;
	vec2 warpCenter = vec2 ( 0.5 , 0.5 ) ;
	vec2 centeredTexcoord = vofi_TexCoord0 . xy - warpCenter ;
	float radialLength = length ( centeredTexcoord ) ;
	vec2 radialDir = normalize ( centeredTexcoord ) ;
	float range = screenWarp_range ;
	float scaledRadialLength = radialLength * range ;
	float tanScaled = tan ( scaledRadialLength ) ;
	float rescaleValue = tan ( 0.5 * range ) ;
	float rescaled = tanScaled / rescaleValue ;
	vec2 warped = warpCenter + vec2 ( 0.5 , 0.5 ) * radialDir * rescaled ;
	fo_FragColor = texture ( samp0 , warped ) ;
}