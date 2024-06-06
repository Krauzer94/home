// filename renderprogs/interactionSM.ps.hlsl
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


uniform vec4 _fa_[30];

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
vec4 idtex2Dproj (sampler2D samp , vec4 texCoords ) {return textureProj ( samp , texCoords. xyw ) ; }
uniform sampler2D samp0;
uniform sampler2D samp1;
uniform sampler2D samp2;
uniform sampler2D samp3;
uniform sampler2D samp4;
uniform sampler2DArrayShadow samp5;
uniform sampler2D samp6;

in vec4 vofi_TexCoord0;
in vec4 vofi_TexCoord1;
in vec4 vofi_TexCoord2;
in vec4 vofi_TexCoord3;
in vec4 vofi_TexCoord4;
in vec4 vofi_TexCoord5;
in vec4 vofi_TexCoord6;
in vec4 vofi_TexCoord7;
in vec4 vofi_TexCoord8;
in vec4 vofi_TexCoord9;
in vec4 vofi_Color;

out vec4 fo_FragColor;

void main() {
	vec4 bumpMap = texture ( samp0 , vofi_TexCoord1 . xy ) ;
	vec4 lightFalloff = ( idtex2Dproj ( samp3 , vofi_TexCoord2 ) ) ;
	vec4 lightProj = ( idtex2Dproj ( samp4 , vofi_TexCoord3 ) ) ;
	vec4 YCoCG = texture ( samp2 , vofi_TexCoord4 . xy ) ;
	vec4 specMapSRGB = texture ( samp1 , vofi_TexCoord5 . xy ) ;
	vec4 specMap = sRGBAToLinearRGBA ( specMapSRGB ) ;
	vec3 lightVector = normalize ( vofi_TexCoord0 . xyz ) ;
	vec3 viewVector = normalize ( vofi_TexCoord6 . xyz ) ;
	vec3 diffuseMap = sRGBToLinearRGB ( ConvertYCoCgToRGB ( YCoCG ) ) ;
	vec3 localNormal ;
	localNormal. xy = bumpMap. wy - 0.5 ;
	localNormal. z = sqrt ( abs ( dot ( localNormal. xy , localNormal. xy ) - 0.25 ) ) ;
	localNormal = normalize ( localNormal ) ;
	float ldotN = saturate ( dot3 ( localNormal , lightVector ) ) ;
	float halfLdotN = dot3 ( localNormal , lightVector ) * 0.5 + 0.5 ;
	halfLdotN *= halfLdotN ;
	float lambert = mix ( ldotN , halfLdotN , 0.5 ) ;
	int shadowIndex = 0 ;
	vec4 shadowMatrixX = _fa_[/* rpShadowMatrices */ 5 + int ( shadowIndex * 4 + 0 ) ] ;
	vec4 shadowMatrixY = _fa_[/* rpShadowMatrices */ 5 + int ( shadowIndex * 4 + 1 ) ] ;
	vec4 shadowMatrixZ = _fa_[/* rpShadowMatrices */ 5 + int ( shadowIndex * 4 + 2 ) ] ;
	vec4 shadowMatrixW = _fa_[/* rpShadowMatrices */ 5 + int ( shadowIndex * 4 + 3 ) ] ;
	vec4 modelPosition = vec4 ( vofi_TexCoord7 . xyz , 1.0 ) ;
	vec4 shadowTexcoord ;
	shadowTexcoord. x = dot4 ( modelPosition , shadowMatrixX ) ;
	shadowTexcoord. y = dot4 ( modelPosition , shadowMatrixY ) ;
	shadowTexcoord. z = dot4 ( modelPosition , shadowMatrixZ ) ;
	shadowTexcoord. w = dot4 ( modelPosition , shadowMatrixW ) ;
	float bias = 0.001 * tan ( acos ( ldotN ) ) ;
	bias = clamp ( bias , 0.0 , 0.01 ) ;
	shadowTexcoord. xyz /= shadowTexcoord. w ;
	shadowTexcoord. z = shadowTexcoord. z * _fa_[0 /* rpScreenCorrectionFactor */] . w ;
	shadowTexcoord. z = shadowTexcoord. z - bias ;
	shadowTexcoord. w = float ( shadowIndex ) ;
	vec2 poissonDisk [ 12 ] = vec2 [ ] (
	vec2 ( 0.6111618 , 0.1050905 ) ,
	vec2 ( 0.1088336 , 0.1127091 ) ,
	vec2 ( 0.3030421 , - 0.6292974 ) ,
	vec2 ( 0.4090526 , 0.6716492 ) ,
	vec2 ( - 0.1608387 , - 0.3867823 ) ,
	vec2 ( 0.7685862 , - 0.6118501 ) ,
	vec2 ( - 0.1935026 , - 0.856501 ) ,
	vec2 ( - 0.4028573 , 0.07754025 ) ,
	vec2 ( - 0.6411021 , - 0.4748057 ) ,
	vec2 ( - 0.1314865 , 0.8404058 ) ,
	vec2 ( - 0.7005203 , 0.4596822 ) ,
	vec2 ( - 0.9713828 , - 0.06329931 ) ) ;
	float shadow = 0.0 ;
	float numSamples = 12.0 ;
	float stepSize = 1.0 / numSamples ;
	vec4 jitterTC = ( gl_FragCoord * _fa_[0 /* rpScreenCorrectionFactor */] ) + _fa_[4 /* rpJitterTexOffset */] ;
	vec4 random = texture ( samp6 , jitterTC. xy ) * 3.14159265358979323846 ;
	vec2 rot ;
	rot. x = cos ( random. x ) ;
	rot. y = sin ( random. x ) ;
	float shadowTexelSize = _fa_[0 /* rpScreenCorrectionFactor */] . z * _fa_[3 /* rpJitterTexScale */] . x ;
	for ( int i = 0 ; i < 12 ; i ++ )
	{
		vec2 jitter = poissonDisk [ i ] ;
		vec2 jitterRotated ;
		jitterRotated. x = jitter. x * rot. x - jitter. y * rot. y ;
		jitterRotated. y = jitter. x * rot. y + jitter. y * rot. x ;
		vec4 shadowTexcoordJittered = vec4 ( shadowTexcoord. xy + jitterRotated * shadowTexelSize , shadowTexcoord. z , shadowTexcoord. w ) ;
		shadow += texture ( samp5 , shadowTexcoordJittered. xywz ) ;
	}
	shadow *= stepSize ;
	vec3 halfAngleVector = normalize ( lightVector + viewVector ) ;
	float hdotN = clamp ( dot3 ( halfAngleVector , localNormal ) , 0.0 , 1.0 ) ;
	float specularPower = 10.0 ;
	vec3 specularContribution = vec3 ( pow ( hdotN , specularPower ) ) ;
	vec3 diffuseColor = diffuseMap * sRGBToLinearRGB ( _fa_[1 /* rpDiffuseModifier */] . xyz ) ;
	vec3 specularColor = specMap. xyz * specularContribution * sRGBToLinearRGB ( _fa_[2 /* rpSpecularModifier */] . xyz ) ;
	vec3 lightColor = sRGBToLinearRGB ( lightProj. xyz * lightFalloff. xyz ) ;
	fo_FragColor . xyz = ( diffuseColor + specularColor ) * lambert * lightColor * vofi_Color . rgb * shadow ;
	fo_FragColor . w = 1.0 ;
}