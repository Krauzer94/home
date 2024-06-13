// filename renderprogs/wobblesky.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[10];

float dot3 (vec3 a , vec3 b ) {return dot ( a , b ) ; }
float dot3 (vec3 a , vec4 b ) {return dot ( a , b. xyz ) ; }
float dot3 (vec4 a , vec3 b ) {return dot ( a. xyz , b ) ; }
float dot3 (vec4 a , vec4 b ) {return dot ( a. xyz , b. xyz ) ; }
float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
vec4 swizzleColor (vec4 c ) {
	return c ;
}

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;

out vec3 vofi_TexCoord0;
out vec4 vofi_Color;

void main() {
	gl_Position . x = dot4 ( in_Position , _va_[3 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[4 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[5 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[6 /* rpMVPmatrixW */] ) ;
	vec3 t0 = in_Position . xyz - _va_[0 /* rpLocalViewOrigin */] . xyz ;
	vofi_TexCoord0 . x = dot3 ( t0 , _va_[7 /* rpWobbleSkyX */] ) ;
	vofi_TexCoord0 . y = dot3 ( t0 , _va_[8 /* rpWobbleSkyY */] ) ;
	vofi_TexCoord0 . z = dot3 ( t0 , _va_[9 /* rpWobbleSkyZ */] ) ;
	vofi_Color = ( swizzleColor ( in_Color ) * _va_[1 /* rpVertexColorModulate */] ) + _va_[2 /* rpVertexColorAdd */] ;
}