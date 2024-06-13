// filename renderprogs/AmbientOcclusion_minify.ps.hlsl
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

uniform sampler2D samp0;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

void main() {
	ivec2 ssP = ivec2 ( vofi_TexCoord0 * _fa_[0 /* rpScreenCorrectionFactor */] . zw ) ;
	int previousMIPNumber = int ( _fa_[1 /* rpJitterTexScale */] . x ) ;
	fo_FragColor . r = texelFetch ( samp0 , clamp ( ssP * 2 + ivec2 ( ssP. y & 1 , ssP. x & 1 ) , ivec2 ( 0 ) , textureSize ( samp0 , previousMIPNumber ) - ivec2 ( 1 ) ) , previousMIPNumber ). r ;
}