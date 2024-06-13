// filename renderprogs/DeepGBufferRadiosity_blur.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable



in vec4 in_Position;
in vec2 in_TexCoord;

out vec2 vofi_TexCoord0;

void main() {
	gl_Position = in_Position ;
	vofi_TexCoord0 = in_TexCoord ;
}