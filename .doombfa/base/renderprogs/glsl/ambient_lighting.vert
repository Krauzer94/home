// filename renderprogs/ambient_lighting.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[13];

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

out vec4 vofi_TexCoord0;
out vec4 vofi_TexCoord1;
out vec4 vofi_TexCoord4;
out vec4 vofi_TexCoord5;
out vec4 vofi_TexCoord6;
out vec4 vofi_Color;

void main() {
	vec4 vNormal = in_Normal * 2.0 - 1.0 ;
	vec4 vTangent = in_Tangent * 2.0 - 1.0 ;
	vec3 vBitangent = cross ( vNormal. xyz , vTangent. xyz ) * vTangent. w ;
	vec4 modelPosition = in_Position ;
	vec3 normal = vNormal. xyz ;
	vec3 tangent = vTangent. xyz ;
	vec3 bitangent = vBitangent. xyz ;
	gl_Position . x = dot4 ( modelPosition , _va_[9 /* rpMVPmatrixX */] ) ;
	gl_Position . y = dot4 ( modelPosition , _va_[10 /* rpMVPmatrixY */] ) ;
	gl_Position . z = dot4 ( modelPosition , _va_[11 /* rpMVPmatrixZ */] ) ;
	gl_Position . w = dot4 ( modelPosition , _va_[12 /* rpMVPmatrixW */] ) ;
	vec4 defaultTexCoord = vec4 ( 0.0 , 0.5 , 0.0 , 1.0 ) ;
	vec4 toLight = normalize ( vec4 ( 0.0 , 0.5 , 1.0 , 1.0 ) ) ;
	vofi_TexCoord0 . x = dot3 ( tangent , toLight ) ;
	vofi_TexCoord0 . y = dot3 ( bitangent , toLight ) ;
	vofi_TexCoord0 . z = dot3 ( normal , toLight ) ;
	vofi_TexCoord0 . w = 1.0 ;
	vofi_TexCoord1 = defaultTexCoord ;
	vofi_TexCoord1 . x = dot4 ( in_TexCoord . xy , _va_[1 /* rpBumpMatrixS */] ) ;
	vofi_TexCoord1 . y = dot4 ( in_TexCoord . xy , _va_[2 /* rpBumpMatrixT */] ) ;
	vofi_TexCoord4 = defaultTexCoord ;
	vofi_TexCoord4 . x = dot4 ( in_TexCoord . xy , _va_[3 /* rpDiffuseMatrixS */] ) ;
	vofi_TexCoord4 . y = dot4 ( in_TexCoord . xy , _va_[4 /* rpDiffuseMatrixT */] ) ;
	vofi_TexCoord5 = defaultTexCoord ;
	vofi_TexCoord5 . x = dot4 ( in_TexCoord . xy , _va_[5 /* rpSpecularMatrixS */] ) ;
	vofi_TexCoord5 . y = dot4 ( in_TexCoord . xy , _va_[6 /* rpSpecularMatrixT */] ) ;
	toLight = normalize ( toLight ) ;
	vec4 toView = normalize ( _va_[0 /* rpLocalViewOrigin */] - modelPosition ) ;
	vec4 halfAngleVector = toLight + toView ;
	vofi_TexCoord6 . x = dot3 ( tangent , halfAngleVector ) ;
	vofi_TexCoord6 . y = dot3 ( bitangent , halfAngleVector ) ;
	vofi_TexCoord6 . z = dot3 ( normal , halfAngleVector ) ;
	vofi_TexCoord6 . w = 1.0 ;
	vofi_Color = ( swizzleColor ( in_Color ) * _va_[7 /* rpVertexColorModulate */] ) + _va_[8 /* rpVertexColorAdd */] ;
}