// filename renderprogs/ambient_lighting.ps.hlsl
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


uniform vec4 _fa_[3];

float dot3 (vec3 a , vec3 b ) {return dot ( a , b ) ; }
float dot3 (vec3 a , vec4 b ) {return dot ( a , b. xyz ) ; }
float dot3 (vec4 a , vec3 b ) {return dot ( a. xyz , b ) ; }
float dot3 (vec4 a , vec4 b ) {return dot ( a. xyz , b. xyz ) ; }
float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
vec3 sRGBToLinearRGB (vec3 rgb ) {
	return rgb ;
}
vec4 sRGBAToLinearRGBA (vec4 rgba ) {
	return rgba ;
}
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
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;

in vec4 vofi_TexCoord0;
in vec4 vofi_TexCoord1;
in vec4 vofi_TexCoord4;
in vec4 vofi_TexCoord5;
in vec4 vofi_TexCoord6;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 bumpMap = texture ( samp0 , vofi_TexCoord1 . xy ) ;
	vec4 YCoCG = texture ( samp2 , vofi_TexCoord4 . xy ) ;
	vec4 specMap = sRGBAToLinearRGBA ( texture ( samp1 , vofi_TexCoord5 . xy ) ) ;
	vec3 lightVector = normalize ( vofi_TexCoord0 . xyz ) ;
	vec3 diffuseMap = sRGBToLinearRGB ( ConvertYCoCgToRGB ( YCoCG ) ) ;
	vec3 localNormal ;
	localNormal. xy = bumpMap. wy - 0.5 ;
	localNormal. z = sqrt ( abs ( dot ( localNormal. xy , localNormal. xy ) - 0.25 ) ) ;
	localNormal = normalize ( localNormal ) ;
	float specularPower = 10.0 ;
	float hDotN = dot3 ( normalize ( vofi_TexCoord6 . xyz ) , localNormal ) ;
	vec3 specularContribution = vec3 ( pow ( abs ( hDotN ) , specularPower ) ) ;
	vec3 diffuseColor = diffuseMap * ( _fa_[0 /* rpDiffuseModifier */] . xyz ) * 1.5 ;
	vec3 specularColor = specMap. xyz * specularContribution * ( _fa_[1 /* rpSpecularModifier */] . xyz ) ;
	float halfLdotN = 1.0 ;
	halfLdotN = dot3 ( localNormal , lightVector ) * 0.5 + 0.5 ;
	halfLdotN *= halfLdotN ;
	float ldotN = dot3 ( localNormal , lightVector ) ;
	vec3 lightColor = sRGBToLinearRGB ( _fa_[2 /* rpAmbientColor */] . rgb ) ;
	float rim = 1.0 - saturate ( hDotN ) ;
	float rimPower = 8.0 ;
	vec3 rimColor = sRGBToLinearRGB ( vec3 ( 0.125 ) * 1.2 ) * lightColor * pow ( rim , rimPower ) ;
	fo_FragColor . xyz = ( ( diffuseColor + specularColor ) * halfLdotN * lightColor + rimColor ) * vofi_Color . rgb ;
	fo_FragColor . w = vofi_Color . a ;
}