// filename renderprogs/gbuffer.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[9];

float dot3 (vec3 a , vec3 b ) {return dot ( a , b ) ; }
float dot3 (vec3 a , vec4 b ) {return dot ( a , b. xyz ) ; }
float dot3 (vec4 a , vec3 b ) {return dot ( a. xyz , b ) ; }
float dot3 (vec4 a , vec4 b ) {return dot ( a. xyz , b. xyz ) ; }
float dot4 (vec4 a , vec4 b ) {return dot ( a , b ) ; }
float dot4 (vec2 a , vec4 b ) {return dot ( vec4 ( a , 0 , 1 ) , b ) ; }
uniform matrices_ubo {vec4 matrices [ 408 ] ; } ;

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;
in vec4 in_Color2;

out vec2 vofi_TexCoord0;
out vec3 vofi_TexCoord1;
out vec3 vofi_TexCoord2;
out vec3 vofi_TexCoord3;
out vec3 vofi_TexCoord4;
out vec4 vofi_Color;

void main() {
	vec4 vNormal = in_Normal * 2.0 - 1.0 ;
	vec4 vTangent = in_Tangent * 2.0 - 1.0 ;
	vec3 vBitangent = cross ( vNormal. xyz , vTangent. xyz ) * vTangent. w ;
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
	vec3 normal ;
	normal. x = dot3 ( matX , vNormal ) ;
	normal. y = dot3 ( matY , vNormal ) ;
	normal. z = dot3 ( matZ , vNormal ) ;
	normal = normalize ( normal ) ;
	vec3 tangent ;
	tangent. x = dot3 ( matX , vTangent ) ;
	tangent. y = dot3 ( matY , vTangent ) ;
	tangent. z = dot3 ( matZ , vTangent ) ;
	tangent = normalize ( tangent ) ;
	vec3 bitangent ;
	bitangent. x = dot3 ( matX , vBitangent ) ;
	bitangent. y = dot3 ( matY , vBitangent ) ;
	bitangent. z = dot3 ( matZ , vBitangent ) ;
	bitangent = normalize ( bitangent ) ;
	vec4 modelPosition ;
	modelPosition. x = dot4 ( matX , in_Position ) ;
	modelPosition. y = dot4 ( matY , in_Position ) ;
	modelPosition. z = dot4 ( matZ , in_Position ) ;
	modelPosition. w = 1.0 ;
	gl_Position . x = dot4 ( modelPosition , _va_[2 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( modelPosition , _va_[3 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( modelPosition , _va_[4 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( modelPosition , _va_[5 /* rpMVPmatrixW */] ) ;
	vofi_TexCoord0 . x = dot4 ( in_TexCoord . xy , _va_[0 /* rpBumpMatrixS */] ) ;
	vofi_TexCoord0 . y = dot4 ( in_TexCoord . xy , _va_[1 /* rpBumpMatrixT */] ) ;
	vofi_TexCoord2 . x = dot3 ( tangent , _va_[6 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . x = dot3 ( tangent , _va_[7 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . x = dot3 ( tangent , _va_[8 /* rpModelViewMatrixZ */] ) ;
	vofi_TexCoord2 . y = dot3 ( bitangent , _va_[6 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . y = dot3 ( bitangent , _va_[7 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . y = dot3 ( bitangent , _va_[8 /* rpModelViewMatrixZ */] ) ;
	vofi_TexCoord2 . z = dot3 ( normal , _va_[6 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . z = dot3 ( normal , _va_[7 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . z = dot3 ( normal , _va_[8 /* rpModelViewMatrixZ */] ) ;
	vofi_Color = vec4 ( 1.0 , 1.0 , 1.0 , 1.0 ) ;
}