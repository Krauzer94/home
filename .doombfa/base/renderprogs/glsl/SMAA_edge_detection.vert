// filename renderprogs/SMAA_edge_detection.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[1];

void SMAAEdgeDetectionVS (vec2 texcoord ,
out vec4 offset [ 3 ] ) {
	offset [ 0 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( - 1.0 , 0.0 , 0.0 , - 1.0 ) + texcoord. xyxy ) ;
	offset [ 1 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( 1.0 , 0.0 , 0.0 , 1.0 ) + texcoord. xyxy ) ;
	offset [ 2 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( - 2.0 , 0.0 , 0.0 , - 2.0 ) + texcoord. xyxy ) ;
}

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;

out vec2 vofi_TexCoord0;
out vec4 vofi_TexCoord1;
out vec4 vofi_TexCoord2;
out vec4 vofi_TexCoord3;

void main() {
	gl_Position = in_Position ;
	vec2 texcoord = in_TexCoord ;
	vofi_TexCoord0 = texcoord ;
	vec4 offset [ 3 ] ;
	SMAAEdgeDetectionVS ( texcoord , offset ) ;
	vofi_TexCoord1 = offset [ 0 ] ;
	vofi_TexCoord2 = offset [ 1 ] ;
	vofi_TexCoord3 = offset [ 2 ] ;
}