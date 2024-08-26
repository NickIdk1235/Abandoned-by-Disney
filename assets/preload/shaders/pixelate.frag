//SHADERTOY PORT FIX (thx bb)
#pragma header
//vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
//SHADERTOY PORT FIX

uniform float PIXELATION_FACTOR;

vec2 getPixelatedSampleCoord(vec2 fragCoord)
{
	float real = PIXELATION_FACTOR;
	if (PIXELATION_FACTOR == 0.0) {
		real = 8.0;
	}
	return fragCoord - mod(fragCoord, real);
}

void main()
{
	vec2 sampleCoord = getPixelatedSampleCoord(fragCoord);
	vec2 uv = sampleCoord / iResolution.xy;
	gl_FragColor = flixel_texture2D(bitmap, uv);
}