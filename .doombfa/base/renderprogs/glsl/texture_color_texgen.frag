// filename renderprogs/texture_color_texgen.ps.hlsl
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

vec4 sRGBAToLinearRGBA (vec4 rgba ) {
	return rgba ;
}
vec4 idtex2Dproj (sampler2D samp , vec4 texCoords ) {return textureProj ( samp , texCoords. xyw ) ; }
uniform sampler2D samp0;

in vec4 vofi_TexCoord0;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 texSample = idtex2Dproj ( samp0 , vofi_TexCoord0 ) ;
	fo_FragColor = sRGBAToLinearRGBA ( texSample ) * vofi_Color ;
}