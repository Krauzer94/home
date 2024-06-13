// filename renderprogs/gbuffer.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[11];

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
	vec4 modelPosition = in_Position ;
	vec3 normal = vNormal. xyz ;
	vec3 tangent = vTangent. xyz ;
	vec3 bitangent = vBitangent. xyz ;
	gl_Position . x = dot4 ( modelPosition , _va_[4 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( modelPosition , _va_[5 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( modelPosition , _va_[6 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( modelPosition , _va_[7 /* rpMVPmatrixW */] ) ;
	vofi_TexCoord0 . x = dot4 ( in_TexCoord . xy , _va_[0 /* rpBumpMatrixS */] ) ;
	vofi_TexCoord0 . y = dot4 ( in_TexCoord . xy , _va_[1 /* rpBumpMatrixT */] ) ;
	vofi_TexCoord2 . x = dot3 ( tangent , _va_[8 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . x = dot3 ( tangent , _va_[9 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . x = dot3 ( tangent , _va_[10 /* rpModelViewMatrixZ */] ) ;
	vofi_TexCoord2 . y = dot3 ( bitangent , _va_[8 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . y = dot3 ( bitangent , _va_[9 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . y = dot3 ( bitangent , _va_[10 /* rpModelViewMatrixZ */] ) ;
	vofi_TexCoord2 . z = dot3 ( normal , _va_[8 /* rpModelViewMatrixX */] ) ;
	vofi_TexCoord3 . z = dot3 ( normal , _va_[9 /* rpModelViewMatrixY */] ) ;
	vofi_TexCoord4 . z = dot3 ( normal , _va_[10 /* rpModelViewMatrixZ */] ) ;
	vofi_Color = ( swizzleColor ( in_Color ) * _va_[2 /* rpVertexColorModulate */] ) + _va_[3 /* rpVertexColorAdd */] ;
}