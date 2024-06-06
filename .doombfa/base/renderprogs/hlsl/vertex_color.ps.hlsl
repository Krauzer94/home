half4 sRGBAToLinearRGBA (half4 rgba )  {
return rgba ; 
} 
struct PS_IN {
float4 color : COLOR0 ; 
} ;
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (PS_IN fragment , out PS_OUT result )  {
result . color = sRGBAToLinearRGBA ( fragment . color ) ; 
} 
