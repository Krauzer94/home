// filename renderprogs/texture_color.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[12];

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

out vec2 vofi_TexCoord0;
out vec4 vofi_Color;

void main() {
	gl_Position . x = dot4 ( in_Position , _va_[3 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( in_Position , _va_[4 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( in_Position , _va_[5 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( in_Position , _va_[6 /* rpMVPmatrixW */] ) ; if ( _va_[11 /* rpTexGen0Enabled */] . x > 0.0 ) {
		vofi_TexCoord0 . x = dot4 ( in_Position , _va_[9 /* rpTexGen0S */] ) ;
		vofi_TexCoord0 . y = dot4 ( in_Position , _va_[10 /* rpTexGen0T */] ) ;
	} else {
		vofi_TexCoord0 . x = dot4 ( in_TexCoord . xy , _va_[7 /* rpTextureMatrixS */] ) ;
		vofi_TexCoord0 . y = dot4 ( in_TexCoord . xy , _va_[8 /* rpTextureMatrixT */] ) ;
	}
	vec4 vertexColor = ( swizzleColor ( in_Color ) * _va_[0 /* rpVertexColorModulate */] ) + _va_[1 /* rpVertexColorAdd */] ;
	vofi_Color = vertexColor * _va_[2 /* rpColor */] ;
}