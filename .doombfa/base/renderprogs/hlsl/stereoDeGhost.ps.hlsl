uniform float4 rpColor : register(c18);
struct PS_OUT {
float4 color : COLOR ; 
} ;
void main (out PS_OUT result )  {
result . color = rpColor ; 
} 
