// filename renderprogs/bloodorb3_capture.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[7];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
vec2 CenterScale (vec2 inTC , vec2 centerScale ) {
	float scaleX = centerScale. x ;
	float scaleY = centerScale. y ;
	vec4 tc0 = vec4 ( scaleX , 0 , 0 , 0.5 - ( 0.5 * scaleX ) ) ;
	vec4 tc1 = vec4 ( 0 , scaleY , 0 , 0.5 - ( 0.5 * scaleY ) ) ;
	vec2 finalTC ;
	finalTC. x = dot4 ( inTC , tc0 ) ;
	finalTC. y = dot4 ( inTC , tc1 ) ;
	return finalTC ;
}
vec2 Rotate2D (vec2 inTC , vec2 cs ) {
	float sinValue = cs. y ;
	float cosValue = cs. x ;
	vec4 tc0 = vec4 ( cosValue , - sinValue , 0 , ( - 0.5 * cosValue ) + ( 0.5 * sinValue ) + 0.5 ) ;
	vec4 tc1 = vec4 ( sinValue , cosValue , 0 , ( - 0.5 * sinValue ) + ( - 0.5 * cosValue ) + 0.5 ) ;
	vec2 finalTC ;
	finalTC. x = dot4 ( inTC , tc0 ) ;
	finalTC. y = dot4 ( inTC , tc1 ) ;
	return finalTC ;
}

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;

out vec2 vofi_TexCoord0;
out vec2 vofi_TexCoord1;
out vec2 vofi_TexCoord2;
out vec2 vofi_TexCoord3;
out vec2 vofi_TexCoord4;

void main() {
	gl_Position . x = dot4 ( in_Position , _va_[0 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[1 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[2 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[3 /* rpMVPmatrixW */] ) ;
	vec4 centerScaleTex = _va_[4 /* rpUser0 */] ;
	vec4 rotateTex = _va_[5 /* rpUser1 */] ;
	vec2 tc0 = CenterScale ( in_TexCoord , centerScaleTex. xy ) ;
	vofi_TexCoord0 = Rotate2D ( tc0 , rotateTex. xy ) ;
	vofi_TexCoord1 = Rotate2D ( tc0 , vec2 ( rotateTex. z , - rotateTex. w ) ) ;
	vofi_TexCoord2 = Rotate2D ( tc0 , rotateTex. zw ) ;
	vofi_TexCoord3 = in_TexCoord ;
	vec4 colorFactor = _va_[6 /* rpUser2 */] ;
	vofi_TexCoord4 = colorFactor. xx ;
}