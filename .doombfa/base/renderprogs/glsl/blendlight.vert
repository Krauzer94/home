// filename renderprogs/blendlight.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[8];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 BINORMAL;
in vec4 in_Color;

out vec4 vofi_TexCoord0;
out vec2 vofi_TexCoord1;

void main() {
	gl_Position . x = dot4 ( in_Position , _va_[0 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[1 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[2 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[3 /* rpMVPmatrixW */] ) ;
	vofi_TexCoord0 . x = dot4 ( in_Position , _va_[4 /* rpTexGen0S */] ) ;
	vofi_TexCoord0 . y = dot4 ( in_Position , _va_[5 /* rpTexGen0T */] ) ;
	vofi_TexCoord0 . z = 0.0 ;
	vofi_TexCoord0 . w = dot4 ( in_Position , _va_[6 /* rpTexGen0Q */] ) ;
	vofi_TexCoord1 . x = dot4 ( in_Position , _va_[7 /* rpTexGen1S */] ) ;
	vofi_TexCoord1 . y = 0.5 ;
}