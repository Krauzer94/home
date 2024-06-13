// filename renderprogs/SMAA_final.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[1];

void SMAANeighborhoodBlendingVS (vec2 texcoord ,
out vec4 offset ) {
	offset = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( 1.0 , 0.0 , 0.0 , 1.0 ) + texcoord. xyxy ) ;
}

in vec4 in_Position;
in vec2 in_TexCoord;
in vec4 in_Normal;
in vec4 in_Tangent;
in vec4 in_Color;

out vec2 vofi_TexCoord0;
out vec4 vofi_TexCoord1;

void main() {
	gl_Position = in_Position ;
	vofi_TexCoord0 = in_TexCoord ;
	vec4 offset ;
	SMAANeighborhoodBlendingVS ( in_TexCoord , offset ) ;
	vofi_TexCoord1 = offset ;
}