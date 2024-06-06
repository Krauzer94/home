uniform float4 rpScreenCorrectionFactor : register(c0);
void SMAAMovc (bool2 cond , inout float2 variable , float2 value )  {if ( cond . x ) variable . x = value . x ; if ( cond . y ) variable . y = value . y ; 
} 
void SMAAMovc (bool4 cond , inout float4 variable , float4 value )  {
SMAAMovc ( cond . xy , variable . xy , value . xy ) ; 
SMAAMovc ( cond . zw , variable . zw , value . zw ) ; 
} 
float2 SMAADecodeDiagBilinearAccess (float2 e )  {













e . r = e . r * abs ( 5.0 * e . r - 5.0 * 0.75 ) ; 
return round ( e ) ; 
} 
float4 SMAADecodeDiagBilinearAccess (float4 e )  {
e . rb = e . rb * abs ( 5.0 * e . rb - 5.0 * 0.75 ) ; 
return round ( e ) ; 
} 
float2 SMAASearchDiag1 (sampler2D edgesTex , float2 texcoord , float2 dir , out float2 e )  {
dir . y = dir . y ; 
float4 coord = float4 ( texcoord , - 1.0 , 1.0 ) ; 
float3 t = float3 ( rpScreenCorrectionFactor . xy , 1.0 ) ; 
while ( coord . z < float ( 8 - 1 ) && 
coord . w > 0.9 ) { 
coord . xyz = ( t * float3 ( dir , 1.0 ) + coord . xyz ) ; 
e = textureLod ( edgesTex , coord . xy , 0.0 ) . rg ; 
coord . w = dot ( e , float2 ( 0.5 , 0.5 ) ) ; 
} 
return coord . zw ; 
} 
float2 SMAASearchDiag2 (sampler2D edgesTex , float2 texcoord , float2 dir , out float2 e )  {
dir . y = dir . y ; 
float4 coord = float4 ( texcoord , - 1.0 , 1.0 ) ; 
coord . x += 0.25 * rpScreenCorrectionFactor . x ; 
float3 t = float3 ( rpScreenCorrectionFactor . xy , 1.0 ) ; 
while ( coord . z < float ( 8 - 1 ) && 
coord . w > 0.9 ) { 
coord . xyz = ( t * float3 ( dir , 1.0 ) + coord . xyz ) ; 



e = textureLod ( edgesTex , coord . xy , 0.0 ) . rg ; 
e = SMAADecodeDiagBilinearAccess ( e ) ; 





coord . w = dot ( e , float2 ( 0.5 , 0.5 ) ) ; 
} 
return coord . zw ; 
} 
float2 SMAAAreaDiag (sampler2D areaTex , float2 dist , float2 e , float offset )  {
float2 texcoord = ( float2 ( 20 , 20 ) * e + dist ) ; 


texcoord = ( ( 1.0 / float2 ( 160.0 , 560.0 ) ) * texcoord + 0.5 * ( 1.0 / float2 ( 160.0 , 560.0 ) ) ) ; 


texcoord . x += 0.5 ; 


texcoord . y += ( 1.0 / 7.0 ) * offset ; 

texcoord . y = texcoord . y ; 


return textureLod ( areaTex , texcoord , 0.0 ) . rg ; 
} 
float2 SMAACalculateDiagWeights (sampler2D edgesTex , sampler2D areaTex , float2 texcoord , float2 e , float4 subsampleIndices )  {
float2 weights = float2 ( 0.0 , 0.0 ) ; 


float4 d ; 
float2 end ; 
if ( e . r > 0.0 ) { 
d . xz = SMAASearchDiag1 ( edgesTex , texcoord , float2 ( - 1.0 , 1.0 ) , end ) ; 
d . x += float ( end . y > 0.9 ) ; 
} else 
d . xz = float2 ( 0.0 , 0.0 ) ; 
d . yw = SMAASearchDiag1 ( edgesTex , texcoord , float2 ( 1.0 , - 1.0 ) , end ) ; 
if ( d . x + d . y > 2.0 ) { 

float4 coords = ( float4 ( - d . x + 0.25 , d . x , d . y , - d . y - 0.25 ) * rpScreenCorrectionFactor . xyxy + texcoord . xyxy ) ; 
float4 c ; 
c . xy = textureLodOffset ( edgesTex , coords . xy , 0.0 , int2 ( - 1 , 0 ) ) . rg ; 
c . zw = textureLodOffset ( edgesTex , coords . zw , 0.0 , int2 ( 1 , 0 ) ) . rg ; 
c . yxwz = SMAADecodeDiagBilinearAccess ( c . xyzw ) ; 










float2 cc = ( float2 ( 2.0 , 2.0 ) * c . xz + c . yw ) ; 


SMAAMovc ( bool2 ( step ( 0.9 , d . zw ) ) , cc , float2 ( 0.0 , 0.0 ) ) ; 


weights += SMAAAreaDiag ( areaTex , d . xy , cc , subsampleIndices . z ) ; 
} 


d . xz = SMAASearchDiag2 ( edgesTex , texcoord , float2 ( - 1.0 , - 1.0 ) , end ) ; 
if ( textureLodOffset ( edgesTex , texcoord , 0.0 , int2 ( 1 , 0 ) ) . r > 0.0 ) { 
d . yw = SMAASearchDiag2 ( edgesTex , texcoord , float2 ( 1.0 , 1.0 ) , end ) ; 
d . y += float ( end . y > 0.9 ) ; 
} else 
d . yw = float2 ( 0.0 , 0.0 ) ; 
if ( d . x + d . y > 2.0 ) { 

float4 coords = ( float4 ( - d . x , - d . x , d . y , d . y ) * rpScreenCorrectionFactor . xyxy + texcoord . xyxy ) ; 
float4 c ; 
c . x = textureLodOffset ( edgesTex , coords . xy , 0.0 , int2 ( - 1 , 0 ) ) . g ; 
c . y = textureLodOffset ( edgesTex , coords . xy , 0.0 , int2 ( 0 , - 1 ) ) . r ; 
c . zw = textureLodOffset ( edgesTex , coords . zw , 0.0 , int2 ( 1 , 0 ) ) . gr ; 
float2 cc = ( float2 ( 2.0 , 2.0 ) * c . xz + c . yw ) ; 


SMAAMovc ( bool2 ( step ( 0.9 , d . zw ) ) , cc , float2 ( 0.0 , 0.0 ) ) ; 


weights += SMAAAreaDiag ( areaTex , d . xy , cc , subsampleIndices . w ) . gr ; 
} 

return weights ; 
} 
float SMAASearchLength (sampler2D searchTex , float2 e , float offset )  {


float2 scale = float2 ( 66.0 , 33.0 ) * float2 ( 0.5 , - 1.0 ) ; 
float2 bias = float2 ( 66.0 , 33.0 ) * float2 ( offset , 1.0 ) ; 


scale += float2 ( - 1.0 , 1.0 ) ; 
bias += float2 ( 0.5 , - 0.5 ) ; 



scale *= 1.0 / float2 ( 64.0 , 16.0 ) ; 
bias *= 1.0 / float2 ( 64.0 , 16.0 ) ; 

float2 coord = ( scale * e + bias ) ; 
coord . y = coord . y ; 


return textureLod ( searchTex , coord , 0.0 ) . r ; 
} 
float SMAASearchXLeft (sampler2D edgesTex , sampler2D searchTex , float2 texcoord , float end )  {






float2 e = float2 ( 0.0 , 1.0 ) ; 
while ( texcoord . x > end && 
e . g > 0.8281 && 
e . r == 0.0 ) { 
e = textureLod ( edgesTex , texcoord , 0.0 ) . rg ; 
texcoord = ( - float2 ( 2.0 , 0.0 ) * rpScreenCorrectionFactor . xy + texcoord ) ; 
} 

float offset = ( - ( 255.0 / 127.0 ) * SMAASearchLength ( searchTex , e , 0.0 ) + 3.25 ) ; 
return ( rpScreenCorrectionFactor . x * offset + texcoord . x ) ; 












} 
float SMAASearchXRight (sampler2D edgesTex , sampler2D searchTex , float2 texcoord , float end )  {
float2 e = float2 ( 0.0 , 1.0 ) ; 
while ( texcoord . x < end && 
e . g > 0.8281 && 
e . r == 0.0 ) { 
e = textureLod ( edgesTex , texcoord , 0.0 ) . rg ; 
texcoord = ( float2 ( 2.0 , 0.0 ) * rpScreenCorrectionFactor . xy + texcoord ) ; 
} 
float offset = ( - ( 255.0 / 127.0 ) * SMAASearchLength ( searchTex , e , 0.5 ) + 3.25 ) ; 
return ( - rpScreenCorrectionFactor . x * offset + texcoord . x ) ; 
} 
float SMAASearchYUp (sampler2D edgesTex , sampler2D searchTex , float2 texcoord , float end )  {
float2 e = float2 ( 1.0 , 0.0 ) ; 
while ( texcoord . y > end && 
e . r > 0.8281 && 
e . g == 0.0 ) { 
e = textureLod ( edgesTex , texcoord , 0.0 ) . rg ; 
texcoord = ( - float2 ( 0.0 , 2.0 ) * rpScreenCorrectionFactor . xy + texcoord ) ; 
} 
float offset = ( - ( 255.0 / 127.0 ) * SMAASearchLength ( searchTex , e . gr , 0.0 ) + 3.25 ) ; 
return ( rpScreenCorrectionFactor . y * offset + texcoord . y ) ; 
} 
float SMAASearchYDown (sampler2D edgesTex , sampler2D searchTex , float2 texcoord , float end )  {
float2 e = float2 ( 1.0 , 0.0 ) ; 
while ( texcoord . y < end && 
e . r > 0.8281 && 
e . g == 0.0 ) { 
e = textureLod ( edgesTex , texcoord , 0.0 ) . rg ; 
texcoord = ( float2 ( 0.0 , 2.0 ) * rpScreenCorrectionFactor . xy + texcoord ) ; 
} 
float offset = ( - ( 255.0 / 127.0 ) * SMAASearchLength ( searchTex , e . gr , 0.5 ) + 3.25 ) ; 
return ( - rpScreenCorrectionFactor . y * offset + texcoord . y ) ; 
} 
float2 SMAAArea (sampler2D areaTex , float2 dist , float e1 , float e2 , float offset )  {

float2 texcoord = ( float2 ( 16 , 16 ) * round ( 4.0 * float2 ( e1 , e2 ) ) + dist ) ; 


texcoord = ( ( 1.0 / float2 ( 160.0 , 560.0 ) ) * texcoord + 0.5 * ( 1.0 / float2 ( 160.0 , 560.0 ) ) ) ; 


texcoord . y = ( ( 1.0 / 7.0 ) * offset + texcoord . y ) ; 

texcoord . y = texcoord . y ; 


return textureLod ( areaTex , texcoord , 0.0 ) . rg ; 
} 
void SMAADetectHorizontalCornerPattern (sampler2D edgesTex , inout float2 weights , float4 texcoord , float2 d )  {
float2 leftRight = step ( d . xy , d . yx ) ; 
float2 rounding = ( 1.0 - ( float ( 25 ) / 100.0 ) ) * leftRight ; 

rounding /= leftRight . x + leftRight . y ; 

float2 factor = float2 ( 1.0 , 1.0 ) ; 
factor . x -= rounding . x * textureLodOffset ( edgesTex , texcoord . xy , 0.0 , int2 ( 0 , 1 ) ) . r ; 
factor . x -= rounding . y * textureLodOffset ( edgesTex , texcoord . zw , 0.0 , int2 ( 1 , 1 ) ) . r ; 
factor . y -= rounding . x * textureLodOffset ( edgesTex , texcoord . xy , 0.0 , int2 ( 0 , - 2 ) ) . r ; 
factor . y -= rounding . y * textureLodOffset ( edgesTex , texcoord . zw , 0.0 , int2 ( 1 , - 2 ) ) . r ; 

weights *= clamp ( factor , 0.0 , 10.0 ) ; 
} 
void SMAADetectVerticalCornerPattern (sampler2D edgesTex , inout float2 weights , float4 texcoord , float2 d )  {
float2 leftRight = step ( d . xy , d . yx ) ; 
float2 rounding = ( 1.0 - ( float ( 25 ) / 100.0 ) ) * leftRight ; 

rounding /= leftRight . x + leftRight . y ; 

float2 factor = float2 ( 1.0 , 1.0 ) ; 
factor . x -= rounding . x * textureLodOffset ( edgesTex , texcoord . xy , 0.0 , int2 ( 1 , 0 ) ) . g ; 
factor . x -= rounding . y * textureLodOffset ( edgesTex , texcoord . zw , 0.0 , int2 ( 1 , 1 ) ) . g ; 
factor . y -= rounding . x * textureLodOffset ( edgesTex , texcoord . xy , 0.0 , int2 ( - 2 , 0 ) ) . g ; 
factor . y -= rounding . y * textureLodOffset ( edgesTex , texcoord . zw , 0.0 , int2 ( - 2 , 1 ) ) . g ; 

weights *= clamp ( factor , 0.0 , 10.0 ) ; 
} 
float4 SMAABlendingWeightCalculationPS (float2 texcoord , 
float2 pixcoord , 
float4 offset [ 3 ] , 
sampler2D edgesTex , 
sampler2D areaTex , 
sampler2D searchTex , 
float4 subsampleIndices )  {
float4 weights = float4 ( 0.0 , 0.0 , 0.0 , 0.0 ) ; 

float2 e = texture ( edgesTex , texcoord ) . rg ; 
if ( e . g > 0.0 ) { 


weights . rg = SMAACalculateDiagWeights ( edgesTex , areaTex , texcoord , e , subsampleIndices ) ; 
if ( weights . r == - weights . g ) { 

float2 d ; 


float3 coords ; 
coords . x = SMAASearchXLeft ( edgesTex , searchTex , offset [ 0 ] . xy , offset [ 2 ] . x ) ; 
coords . y = offset [ 1 ] . y ; 
d . x = coords . x ; 




float e1 = textureLod ( edgesTex , coords . xy , 0.0 ) . r ; 


coords . z = SMAASearchXRight ( edgesTex , searchTex , offset [ 0 ] . zw , offset [ 2 ] . y ) ; 
d . y = coords . z ; 



d = abs ( round ( ( rpScreenCorrectionFactor . zz * d + - pixcoord . xx ) ) ) ; 



float2 sqrt_d = sqrt ( d ) ; 


float e2 = textureLodOffset ( edgesTex , coords . zy , 0.0 , int2 ( 1 , 0 ) ) . r ; 



weights . rg = SMAAArea ( areaTex , sqrt_d , e1 , e2 , subsampleIndices . y ) ; 


coords . y = texcoord . y ; 
SMAADetectHorizontalCornerPattern ( edgesTex , weights . rg , coords . xyzy , d ) ; 
} else 
e . r = 0.0 ; 
} 
if ( e . r > 0.0 ) { 
float2 d ; 


float3 coords ; 
coords . y = SMAASearchYUp ( edgesTex , searchTex , offset [ 1 ] . xy , offset [ 2 ] . z ) ; 
coords . x = offset [ 0 ] . x ; 
d . x = coords . y ; 


float e1 = textureLod ( edgesTex , coords . xy , 0.0 ) . g ; 


coords . z = SMAASearchYDown ( edgesTex , searchTex , offset [ 1 ] . zw , offset [ 2 ] . w ) ; 
d . y = coords . z ; 


d = abs ( round ( ( rpScreenCorrectionFactor . ww * d + - pixcoord . yy ) ) ) ; 



float2 sqrt_d = sqrt ( d ) ; 


float e2 = textureLodOffset ( edgesTex , coords . xz , 0.0 , int2 ( 0 , 1 ) ) . g ; 


weights . ba = SMAAArea ( areaTex , sqrt_d , e1 , e2 , subsampleIndices . x ) ; 


coords . x = texcoord . x ; 
SMAADetectVerticalCornerPattern ( edgesTex , weights . ba , coords . xyxz , d ) ; 
} 

return weights ; 
} 
uniform sampler2D samp0 : register(s0);
uniform sampler2D samp1 : register(s1);
uniform sampler2D samp2 : register(s2);
struct PS_IN {
float4 position : WPOS ; 
float2 texcoord0 : TEXCOORD0_centroid ; 
float4 texcoord1 : TEXCOORD1_centroid ; 
float4 texcoord2 : TEXCOORD2_centroid ; 
float4 texcoord3 : TEXCOORD3_centroid ; 
float4 texcoord4 : TEXCOORD4_centroid ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
float2 texcoord = fragment . texcoord0 ; 

float4 offset [ 3 ] ; 
offset [ 0 ] = fragment . texcoord1 ; 
offset [ 1 ] = fragment . texcoord2 ; 
offset [ 2 ] = fragment . texcoord3 ; 

float2 pixcoord = fragment . texcoord4 . st ; 



float4 subsampleIndices = float4 ( 0.0 , 0.0 , 0.0 , 0.0 ) ; 

float4 color = SMAABlendingWeightCalculationPS ( texcoord , 
pixcoord , 
offset , 
samp0 , 
samp1 , 
samp2 , 
subsampleIndices ) ; 


result . color = color ; 
} 
