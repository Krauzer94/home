// filename renderprogs/bumpyenvironment_skinned.ps.hlsl
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

float dot3 (vec3 a , vec3 b ) {return dot ( a , b ) ; }
float dot3 (vec3 a , vec4 b ) {return dot ( a , b. xyz ) ; }
float dot3 (vec4 a , vec3 b ) {return dot ( a. xyz , b ) ; }
float dot3 (vec4 a , vec4 b ) {return dot ( a. xyz , b. xyz ) ; }
vec3 sRGBToLinearRGB (vec3 rgb ) {
	return rgb ;
}
uniform samplerCube samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;
in vec3 vofi_TexCoord1;
in vec3 vofi_TexCoord2;
in vec3 vofi_TexCoord3;
in vec3 vofi_TexCoord4;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 bump = texture ( samp1 , vofi_TexCoord0 ) * 2.0 - 1.0 ;
	vec3 localNormal ;
	localNormal = vec3 ( bump. wy , 0.0 ) ;
	localNormal. z = sqrt ( 1.0 - dot3 ( localNormal , localNormal ) ) ;
	vec3 globalNormal ;
	globalNormal. x = dot3 ( localNormal , vofi_TexCoord2 ) ;
	globalNormal. y = dot3 ( localNormal , vofi_TexCoord3 ) ;
	globalNormal. z = dot3 ( localNormal , vofi_TexCoord4 ) ;
	vec3 globalEye = normalize ( vofi_TexCoord1 ) ;
	vec3 reflectionVector = globalNormal * dot3 ( globalEye , globalNormal ) ;
	reflectionVector = ( reflectionVector * 2.0 ) - globalEye ;
	vec4 envMap = texture ( samp0 , reflectionVector ) ;
	fo_FragColor = vec4 ( sRGBToLinearRGB ( envMap. xyz ) , 1.0 ) * vofi_Color ;
}