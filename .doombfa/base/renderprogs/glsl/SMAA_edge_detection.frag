// filename renderprogs/SMAA_edge_detection.ps.hlsl
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

vec2 SMAALumaEdgeDetectionPS (vec2 texcoord ,
vec4 offset [ 3 ] ,
sampler2D colorTex
) {
	vec2 threshold = vec2 ( 0.1 , 0.1 ) ;
	vec3 weights = vec3 ( 0.2126 , 0.7152 , 0.0722 ) ;
	float L = dot ( texture ( colorTex , texcoord ). rgb , weights ) ;
	float Lleft = dot ( texture ( colorTex , offset [ 0 ]. xy ). rgb , weights ) ;
	float Ltop = dot ( texture ( colorTex , offset [ 0 ]. zw ). rgb , weights ) ;
	vec4 delta ;
	delta. xy = abs ( L - vec2 ( Lleft , Ltop ) ) ;
	vec2 edges = step ( threshold , delta. xy ) ;
	if ( dot ( edges , vec2 ( 1.0 , 1.0 ) ) == 0.0 )
	discard ;
	float Lright = dot ( texture ( colorTex , offset [ 1 ]. xy ). rgb , weights ) ;
	float Lbottom = dot ( texture ( colorTex , offset [ 1 ]. zw ). rgb , weights ) ;
	delta. zw = abs ( L - vec2 ( Lright , Lbottom ) ) ;
	vec2 maxDelta = max ( delta. xy , delta. zw ) ;
	float Lleftleft = dot ( texture ( colorTex , offset [ 2 ]. xy ). rgb , weights ) ;
	float Ltoptop = dot ( texture ( colorTex , offset [ 2 ]. zw ). rgb , weights ) ;
	delta. zw = abs ( vec2 ( Lleft , Ltop ) - vec2 ( Lleftleft , Ltoptop ) ) ;
	maxDelta = max ( maxDelta. xy , delta. zw ) ;
	float finalDelta = max ( maxDelta. x , maxDelta. y ) ;
	edges. xy *= step ( finalDelta , 2.0 * delta. xy ) ;
	return edges ;
}
uniform sampler2D samp0;

in vec2 vofi_TexCoord0;
in vec4 vofi_TexCoord1;
in vec4 vofi_TexCoord2;
in vec4 vofi_TexCoord3;

out vec4 fo_FragColor;

void main() {
	vec2 tCoords = vofi_TexCoord0 ;
	vec4 offset [ 3 ] ;
	offset [ 0 ] = vofi_TexCoord1 ;
	offset [ 1 ] = vofi_TexCoord2 ;
	offset [ 2 ] = vofi_TexCoord3 ;
	vec4 color = vec4 ( 0.0 ) ;
	color. rg = SMAALumaEdgeDetectionPS ( tCoords ,
	offset ,
	samp0
	) ;
	fo_FragColor = color ;
}