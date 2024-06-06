// filename renderprogs/hdr_glare_chromatic.ps.hlsl
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

uniform sampler2D samp0;

in vec2 vofi_TexCoord0;

out vec4 fo_FragColor;

void main() {
	vec2 st = vofi_TexCoord0 ;
	vec4 color = texture ( samp0 , st ) ;
	float gaussFact [ 9 ] = float [ 9 ] ( 0.13298076 , 0.12579441 , 0.10648267 , 0.08065691 , 0.05467002 , 0.03315905 , 0.01799699 , 0.00874063 , 0.00379866 ) ;
	vec3 chromaticOffsets [ 9 ] = vec3 [ ] (
	vec3 ( 0.5 , 0.5 , 0.5 ) ,
	vec3 ( 0.8 , 0.3 , 0.3 ) ,
	vec3 ( 0.5 , 0.2 , 0.8 ) ,
	vec3 ( 0.2 , 0.2 , 1.0 ) ,
	vec3 ( 0.2 , 0.3 , 0.9 ) ,
	vec3 ( 0.2 , 0.9 , 0.2 ) ,
	vec3 ( 0.3 , 0.5 , 0.3 ) ,
	vec3 ( 0.3 , 0.5 , 0.3 ) ,
	vec3 ( 0.3 , 0.5 , 0.3 )
	) ;
	vec3 sumColor = vec3 ( 0.0 ) ;
	vec3 sumSpectrum = vec3 ( 0.0 ) ;
	int tap = 4 ;
	int samples = 9 ;
	float scale = 13.0 ;
	float weightScale = 1.9 ;
	for ( int i = 0 ; i < samples ; i ++ )
	{
		vec3 so = chromaticOffsets [ i ] ;
		vec4 color = texture ( samp0 , st + vec2 ( float ( i ) , 0 ) * _fa_[0 /* rpWindowCoord */] . xy * scale ) ;
		float weight = gaussFact [ i ] ;
		sumColor += color. rgb * ( so. rgb * weight * weightScale ) ;
	}
	for ( int i = 1 ; i < samples ; i ++ )
	{
		vec3 so = chromaticOffsets [ i ] ;
		vec4 color = texture ( samp0 , st + vec2 ( float ( - i ) , 0 ) * _fa_[0 /* rpWindowCoord */] . xy * scale ) ;
		float weight = gaussFact [ i ] ;
		sumColor += color. rgb * ( so. rgb * weight * weightScale ) ;
	}
	fo_FragColor = vec4 ( sumColor , 1.0 ) ;
}