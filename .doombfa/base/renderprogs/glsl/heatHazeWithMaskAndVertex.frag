// filename renderprogs/heatHazeWithMaskAndVertex.ps.hlsl
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

vec2 vposToScreenPosTexCoord (vec2 vpos ) {return vpos. xy * _fa_[0 /* rpWindowCoord */] . xy ; }
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;

in vec4 vofi_TexCoord0;
in vec4 vofi_TexCoord1;
in vec4 vofi_TexCoord2;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 mask = texture ( samp2 , vofi_TexCoord0 . xy ) ;
	mask. xy *= vofi_Color . xy ;
	mask. xy -= 0.01 ;
	clip ( mask ) ;
	vec4 bumpMap = ( texture ( samp1 , vofi_TexCoord1 . xy ) * 2.0 ) - 1.0 ;
	vec2 localNormal = bumpMap. wy ;
	localNormal *= mask. xy ;
	vec2 screenTexCoord = vposToScreenPosTexCoord ( gl_FragCoord . xy ) ;
	screenTexCoord += ( localNormal * vofi_TexCoord2 . xy ) ;
	screenTexCoord = saturate ( screenTexCoord ) ;
	fo_FragColor = ( texture ( samp0 , screenTexCoord ) ) ;
}