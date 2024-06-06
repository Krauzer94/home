// filename renderprogs/SMAA_final.ps.hlsl
#version 460
#pragma shader_stage( fragment )
#extension GL_ARB_separate_shader_objects : enable

void clip( float v ) { if ( v < 0.0 ) { discard; } }
void clip( vec2 v ) { if ( any( lessThan( v, vec2( 0.0 ) ) ) ) { discard; } }
void clip( vec3 v ) { if ( any( lessThan( v, vec3( 0.0 ) ) ) ) { discard; } }
void clip( vec4 v ) { if ( any( lessThan( v, vec4( 0.0 ) ) ) ) { discard; } }

float saturate( float v ) { return clamp( v, 0.0, 1.0 ); }
vec2 saturate( vec2 v ) { return clamp( v, 0.0, 1.0 ); }
vec3 saturate( vec3 v ) { return clamp( v, 0.0, 1.0 ); }
vec4 saturate( vec4 v ) { return clamp( v, 0.0, 1.0 ); }


uniform vec4 _fa_[1];

void SMAAMovc (bvec2 cond , inout vec2 variable , vec2 value ) {if ( cond. x ) variable. x = value. x ; if ( cond. y ) variable. y = value. y ;
}
void SMAAMovc (bvec4 cond , inout vec4 variable , vec4 value ) {
	SMAAMovc ( cond. xy , variable. xy , value. xy ) ;
	SMAAMovc ( cond. zw , variable. zw , value. zw ) ;
}
vec4 SMAANeighborhoodBlendingPS (vec2 texcoord ,
vec4 offset ,
sampler2D colorTex ,
sampler2D blendTex
) {
	vec4 a ;
	a. x = texture ( blendTex , offset. xy ). a ;
	a. y = texture ( blendTex , offset. zw ). g ;
	a. wz = texture ( blendTex , texcoord ). xz ;
	if ( dot ( a , vec4 ( 1.0 , 1.0 , 1.0 , 1.0 ) ) < 1e-5 ) {
		vec4 color = textureLod ( colorTex , texcoord , 0.0 ) ;
		return color ;
	} else {
		bool h = max ( a. x , a. z ) > max ( a. y , a. w ) ;
		vec4 blendingOffset = vec4 ( 0.0 , a. y , 0.0 , a. w ) ;
		vec2 blendingWeight = a. yw ;
		SMAAMovc ( bvec4 ( h , h , h , h ) , blendingOffset , vec4 ( a. x , 0.0 , a. z , 0.0 ) ) ;
		SMAAMovc ( bvec2 ( h , h ) , blendingWeight , a. xz ) ;
		blendingWeight /= dot ( blendingWeight , vec2 ( 1.0 , 1.0 ) ) ;
		vec4 blendingCoord = ( blendingOffset * vec4 ( _fa_[0 /* rpScreenCorrectionFactor */] . xy , - _fa_[0 /* rpScreenCorrectionFactor */] . xy ) + texcoord. xyxy ) ;
		vec4 color = blendingWeight. x * textureLod ( colorTex , blendingCoord. xy , 0.0 ) ;
		color += blendingWeight. y * textureLod ( colorTex , blendingCoord. zw , 0.0 ) ;
		return color ;
	}
}
uniform sampler2D samp0;
uniform sampler2D samp1;

in vec2 vofi_TexCoord0;
in vec4 vofi_TexCoord1;

out vec4 fo_FragColor;

void main() {
	vec2 texcoord = vofi_TexCoord0 ;
	vec4 offset = vofi_TexCoord1 ;
	vec4 color = SMAANeighborhoodBlendingPS ( texcoord ,
	offset ,
	samp0 ,
	samp1
	) ;
	fo_FragColor = color ;
}