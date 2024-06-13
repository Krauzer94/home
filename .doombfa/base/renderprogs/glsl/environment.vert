// filename renderprogs/environment.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[6];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
vec4 sRGBAToLinearRGBA (vec4 rgba ) {
	return rgba ;
}

in vec4 in_Position;
in vec4 in_Normal;
in vec4 in_Color;

out vec3 vofi_TexCoord0;
out vec3 vofi_TexCoord1;
out vec4 vofi_Color;

void main() {
	vec4 vNormal = in_Normal * 2.0 - 1.0 ;
	gl_Position . x = dot4 ( in_Position , _va_[2 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[3 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[4 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[5 /* rpMVPmatrixW */] ) ;
	vec4 toEye = _va_[0 /* rpLocalViewOrigin */] - in_Position ;
	vofi_TexCoord0 = toEye. xyz ;
	vofi_TexCoord1 = vNormal. xyz ;
	vofi_Color = sRGBAToLinearRGBA ( _va_[1 /* rpColor */] ) ;
}