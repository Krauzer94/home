// filename renderprogs/SMAA_blending_weight_calc.vs.hlsl
#version 460
#pragma shader_stage( vertex )
#extension GL_ARB_separate_shader_objects : enable


uniform vec4 _va_[1];

void SMAABlendingWeightCalculationVS (vec2 texcoord ,
out vec2 pixcoord ,
out vec4 offset [ 3 ] ) {
	pixcoord = texcoord * _va_[0 /* rpScreenCorrectionFactor */] . zw ;
	offset [ 0 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( - 0.25 , - 0.125 , 1.25 , - 0.125 ) + texcoord. xyxy ) ;
	offset [ 1 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xyxy * vec4 ( - 0.125 , - 0.25 , - 0.125 , 1.25 ) + texcoord. xyxy ) ;
	offset [ 2 ] = ( _va_[0 /* rpScreenCorrectionFactor */] . xxyy *
	vec4 ( - 2.0 , 2.0 , - 2.0 , 2.0 ) * float ( 16 ) +
	vec4 ( offset [ 0 ]. xz , offset [ 1 ]. yw ) ) ;
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
out vec4 vofi_TexCoord4;

void main() {
	gl_Position = in_Position ;
	vec2 texcoord = in_TexCoord ;
	vofi_TexCoord0 = texcoord ;
	vec4 offset [ 3 ] ;
	vec2 pixcoord ;
	SMAABlendingWeightCalculationVS ( texcoord , pixcoord , offset ) ;
	vofi_TexCoord1 = offset [ 0 ] ;
	vofi_TexCoord2 = offset [ 1 ] ;
	vofi_TexCoord3 = offset [ 2 ] ;
	vofi_TexCoord4 . st = pixcoord ;
}