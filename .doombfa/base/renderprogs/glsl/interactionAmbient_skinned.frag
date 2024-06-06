// filename renderprogs/interactionAmbient_skinned.ps.hlsl
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

float dot3 (vec3 a , vec3 b ) {return dot ( a , b ) ; }
float dot3 (vec3 a , vec4 b ) {return dot ( a , b. xyz ) ; }
float dot3 (vec4 a , vec3 b ) {return dot ( a. xyz , b ) ; }
float dot3 (vec4 a , vec4 b ) {return dot ( a. xyz , b. xyz ) ; }
float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
const vec4 matrixCoCg1YtoRGB1X = vec4( 1.0, -1.0, 0.0, 1.0 );
const vec4 matrixCoCg1YtoRGB1Y = vec4( 0.0, 1.0, -0.50196078, 1.0 );
const vec4 matrixCoCg1YtoRGB1Z = vec4( -1.0, -1.0, 1.00392156, 1.0 );
vec3 ConvertYCoCgToRGB (vec4 YCoCg ) {
	vec3 rgbColor ;
	YCoCg. z = ( YCoCg. z * 31.875 ) + 1.0 ;
	YCoCg. z = 1.0 / YCoCg. z ;
	YCoCg. xy *= YCoCg. z ;
	rgbColor. x = dot4 ( YCoCg , matrixCoCg1YtoRGB1X ) ;
	rgbColor. y = dot4 ( YCoCg , matrixCoCg1YtoRGB1Y ) ;
	rgbColor. z = dot4 ( YCoCg , matrixCoCg1YtoRGB1Z ) ;
	return rgbColor ;
}
vec4 idtex2Dproj (sampler2D samp , vec4 texCoords ) {return textureProj ( samp , texCoords. xyw ) ; }
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;
uniform sampler2D samp3;
uniform sampler2D samp4;

in vec4 vofi_TexCoord1;
in vec4 vofi_TexCoord2;
in vec4 vofi_TexCoord3;
in vec4 vofi_TexCoord4;
in vec4 vofi_TexCoord5;
in vec4 vofi_TexCoord6;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 bumpMap = texture ( samp0 , vofi_TexCoord1 . xy ) ;
	vec4 lightFalloff = idtex2Dproj ( samp3 , vofi_TexCoord2 ) ;
	vec4 lightProj = idtex2Dproj ( samp4 , vofi_TexCoord3 ) ;
	vec4 YCoCG = texture ( samp2 , vofi_TexCoord4 . xy ) ;
	vec4 specMap = texture ( samp1 , vofi_TexCoord5 . xy ) ;
	vec3 ambientLightVector = vec3 ( 0.5 , 9.5 - 0.385 , 0.8925 ) ;
	vec3 lightVector = normalize ( ambientLightVector ) ;
	vec3 diffuseMap = ConvertYCoCgToRGB ( YCoCG ) ;
	vec3 localNormal ;
	localNormal. xy = bumpMap. wy - 0.5 ;
	localNormal. z = sqrt ( abs ( dot ( localNormal. xy , localNormal. xy ) - 0.25 ) ) ;
	localNormal = normalize ( localNormal ) ;
	float ldotN = saturate ( dot3 ( localNormal , lightVector ) ) ;
	float halfLdotN = dot3 ( localNormal , lightVector ) * 0.5 + 0.5 ;
	halfLdotN *= halfLdotN ;
	float lambert = halfLdotN ;
	float specularPower = 10.0 ;
	float hDotN = dot3 ( normalize ( vofi_TexCoord6 . xyz ) , localNormal ) ;
	vec3 specularContribution = vec3 ( pow ( abs ( hDotN ) , specularPower ) ) ;
	vec3 diffuseColor = diffuseMap * _fa_[0 /* rpDiffuseModifier */] . xyz ;
	vec3 specularColor = specMap. xyz * specularContribution * _fa_[1 /* rpSpecularModifier */] . xyz ;
	vec3 lightColor = 1.0 * lightProj. xyz * lightFalloff. xyz ;
	fo_FragColor . xyz = ( diffuseColor + specularColor ) * lightColor * vofi_Color . xyz ;
	fo_FragColor . w = 1.0 ;
}