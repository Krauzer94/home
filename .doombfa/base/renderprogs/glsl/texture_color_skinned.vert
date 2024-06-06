// filename renderprogs/texture_color_skinned.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[12];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
vec4 swizzleColor (vec4 c ) {
	return c ;
}
uniform matrices_ubo {vec4 matrices [ 408 ] ; } ;

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Color;
in vec4 in_Color2;

out vec2 vofi_TexCoord0;
out vec4 vofi_Color;

void main() {
	float w0 = in_Color2 . x ;
	float w1 = in_Color2 . y ;
	float w2 = in_Color2 . z ;
	float w3 = in_Color2 . w ;
	vec4 matX , matY , matZ ;
	int joint = int ( in_Color . x * 255.1 * 3.0 ) ;
	matX = matrices [ int ( joint + 0 ) ] * w0 ;
	matY = matrices [ int ( joint + 1 ) ] * w0 ;
	matZ = matrices [ int ( joint + 2 ) ] * w0 ;
	joint = int ( in_Color . y * 255.1 * 3.0 ) ;
	matX += matrices [ int ( joint + 0 ) ] * w1 ;
	matY += matrices [ int ( joint + 1 ) ] * w1 ;
	matZ += matrices [ int ( joint + 2 ) ] * w1 ;
	joint = int ( in_Color . z * 255.1 * 3.0 ) ;
	matX += matrices [ int ( joint + 0 ) ] * w2 ;
	matY += matrices [ int ( joint + 1 ) ] * w2 ;
	matZ += matrices [ int ( joint + 2 ) ] * w2 ;
	joint = int ( in_Color . w * 255.1 * 3.0 ) ;
	matX += matrices [ int ( joint + 0 ) ] * w3 ;
	matY += matrices [ int ( joint + 1 ) ] * w3 ;
	matZ += matrices [ int ( joint + 2 ) ] * w3 ;
	vec4 modelPosition ;
	modelPosition. x = dot4 ( matX , in_Position ) ;
	modelPosition. y = dot4 ( matY , in_Position ) ;
	modelPosition. z = dot4 ( matZ , in_Position ) ;
	modelPosition. w = 1.0 ;
	gl_Position . x = dot4 ( modelPosition , _va_[3 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( modelPosition , _va_[4 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( modelPosition , _va_[5 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( modelPosition , _va_[6 /* rpMVPmatrixW */] ) ; if ( _va_[11 /* rpTexGen0Enabled */] . x > 0.0 ) {
		vofi_TexCoord0 . x = dot4 ( modelPosition , _va_[9 /* rpTexGen0S */] ) ;
		vofi_TexCoord0 . y = dot4 ( modelPosition , _va_[10 /* rpTexGen0T */] ) ;
	} else {
		vofi_TexCoord0 . x = dot4 ( in_TexCoord . xy , _va_[7 /* rpTextureMatrixS */] ) ;
		vofi_TexCoord0 . y = dot4 ( in_TexCoord . xy , _va_[8 /* rpTextureMatrixT */] ) ;
	}
	vec4 vertexColor = ( swizzleColor ( in_Color ) * _va_[0 /* rpVertexColorModulate */] ) + _va_[1 /* rpVertexColorAdd */] ;
	vofi_Color = vertexColor * _va_[2 /* rpColor */] ;
}