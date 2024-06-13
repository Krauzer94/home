// filename renderprogs/shadow_skinned.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[5];

float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
uniform matrices_ubo {vec4 matrices [ 408 ] ; } ;

in vec4 in_Position;
in vec4 in_Color;
in vec4 in_Color2;


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
	vec4 vertexPosition = in_Position ;
	vertexPosition. w = 1.0 ;
	vec4 modelPosition ;
	modelPosition. x = dot4 ( matX , vertexPosition ) ;
	modelPosition. y = dot4 ( matY , vertexPosition ) ;
	modelPosition. z = dot4 ( matZ , vertexPosition ) ;
	modelPosition. w = in_Position . w ;
	vec4 vPos = modelPosition - _va_[0 /* rpLocalLightOrigin */] ;
	vPos = ( vPos. wwww * _va_[0 /* rpLocalLightOrigin */] ) + vPos ;
	gl_Position . x = dot4 ( vPos , _va_[1 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( vPos , _va_[2 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( vPos , _va_[3 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( vPos , _va_[4 /* rpMVPmatrixW */] ) ;
}