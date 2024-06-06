uniform float4 rpDiffuseModifier : register(c2);
uniform float4 rpSpecularModifier : register(c3);
static float dot3 (float3 a , float3 b )  {return dot ( a , b ) ; } 
static float dot3 (float3 a , float4 b )  {return dot ( a , b . xyz ) ; } 
static float dot3 (float4 a , float3 b )  {return dot ( a . xyz , b ) ; } 
static float dot3 (float4 a , float4 b )  {return dot ( a . xyz , b . xyz ) ; } 
static float dot4 (float4 a , float4 b )  {return dot ( a , b ) ; } 
static float dot4 (float2 a , float4 b )  {return dot ( float4 ( a , 0 , 1 ) , b ) ; } 
half3 sRGBToLinearRGB (half3 rgb )  {
return rgb ; 
} 
half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
static const half4 matrixCoCg1YtoRGB1X = half4( 1.0, -1.0, 0.0, 1.0 );
static const half4 matrixCoCg1YtoRGB1Y = half4( 0.0, 1.0, -0.50196078, 1.0 );
static const half4 matrixCoCg1YtoRGB1Z = half4( -1.0, -1.0, 1.00392156, 1.0 );
static half3 ConvertYCoCgToRGB (half4 YCoCg )  {
half3 rgbColor ; 

YCoCg . z = ( YCoCg . z * 31.875 ) + 1.0 ; 
YCoCg . z = 1.0 / YCoCg . z ; 
YCoCg . xy *= YCoCg . z ; 
rgbColor . x = dot4 ( YCoCg , matrixCoCg1YtoRGB1X ) ; 
rgbColor . y = dot4 ( YCoCg , matrixCoCg1YtoRGB1Y ) ; 
rgbColor . z = dot4 ( YCoCg , matrixCoCg1YtoRGB1Z ) ; 
return rgbColor ; 
} 
static float4 idtex2Dproj (sampler2D samp , float4 texCoords )  {return tex2Dproj ( samp , texCoords . xyw ) ; } 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
uniform sampler2D samp3 : register(s3);
uniform sampler2D samp4 : register(s4);
struct PS_IN {
half4 position : WPOS ; 
half4 texcoord1 : TEXCOORD1_centroid ; 
half4 texcoord2 : TEXCOORD2_centroid ; 
half4 texcoord3 : TEXCOORD3_centroid ; 
half4 texcoord4 : TEXCOORD4_centroid ; 
half4 texcoord5 : TEXCOORD5_centroid ; 
half4 texcoord6 : TEXCOORD6_centroid ; 
half4 color : COLOR0 ; 
} ;
struct PS_OUT {
half4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
half4 bumpMap = tex2D ( samp0 , fragment . texcoord1 . xy ) ; 
half4 lightFalloff = idtex2Dproj ( samp3 , fragment . texcoord2 ) ; 
half4 lightProj = idtex2Dproj ( samp4 , fragment . texcoord3 ) ; 
half4 YCoCG = tex2D ( samp2 , fragment . texcoord4 . xy ) ; 
half4 specMap = sRGBAToLinearRGBA ( tex2D ( samp1 , fragment . texcoord5 . xy ) ) ; 

const half3 ambientLightVector = half3 ( 0.5 , 9.5 - 0.385 , 0.8925 ) ; 
half3 lightVector = normalize ( ambientLightVector ) ; 
half3 diffuseMap = sRGBToLinearRGB ( ConvertYCoCgToRGB ( YCoCG ) ) ; 

half3 localNormal ; 
localNormal . xy = bumpMap . wy - 0.5 ; 

localNormal . z = sqrt ( abs ( dot ( localNormal . xy , localNormal . xy ) - 0.25 ) ) ; 
localNormal = normalize ( localNormal ) ; 


half ldotN = saturate ( dot3 ( localNormal , lightVector ) ) ; 

half halfLdotN = dot3 ( localNormal , lightVector ) * 0.5 + 0.5 ; 
halfLdotN *= halfLdotN ; 

half lambert = halfLdotN ; 

const half specularPower = 10.0 ; 
half hDotN = dot3 ( normalize ( fragment . texcoord6 . xyz ) , localNormal ) ; 

half3 specularContribution = half3 ( pow ( abs ( hDotN ) , specularPower ) ) ; 

half3 diffuseColor = diffuseMap * sRGBToLinearRGB ( rpDiffuseModifier . xyz ) ; 
half3 specularColor = specMap . xyz * specularContribution * sRGBToLinearRGB ( rpSpecularModifier . xyz ) ; 
half3 lightColor = 1.0 * lightProj . xyz * lightFalloff . xyz ; 

result . color . xyz = ( diffuseColor + specularColor ) * lightColor * fragment . color . xyz ; 
result . color . w = 1.0 ; 
} 
