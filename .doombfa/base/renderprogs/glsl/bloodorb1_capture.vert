// filename renderprogs/bloodorb1_capture.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[5];

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

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;

out vec2 vofi_TexCoord0;
out vec2 vofi_TexCoord1;

void main() {
	gl_Position . x = dot4 ( in_Position , _va_[0 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[1 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[2 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[3 /* rpMVPmatrixW */] ) ;
	vec4 centerScale = _va_[4 /* rpUser0 */] ;
	vofi_TexCoord0 = CenterScale ( in_TexCoord , centerScale. xy ) ;
	vofi_TexCoord1 = in_TexCoord ;
}