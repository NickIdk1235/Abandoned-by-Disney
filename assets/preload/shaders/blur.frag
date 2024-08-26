#pragma header
#define iTime total_time
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
//https://github.com/bbpanzu/FNF-Sunday/blob/main/source_sunday/RadialBlur.hx
//https://www.shadertoy.com/view/XsfSDs
uniform float cx; //center x (0.0 - 1.0)
uniform float cy; //center y (0.0 - 1.0)
uniform float blurWidth; // blurAmount

const int nsamples = 30; //samples

void main()
{
	vec2 uv = openfl_TextureCoordv.xy;
	vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
	vec2 iResolution = openfl_TextureSize;
	float realcx = cx;
	float realcy = cy;

	if (cx == 0.0) {
		realcx = 0.5;
	}
	if (cy == 0.0) {
		realcy = 0.5;
	}

	vec4 color = texture2D(bitmap, openfl_TextureCoordv);
	vec2 res = openfl_TextureCoordv;
	vec2 pp = vec2(realcx, realcy);
	vec2 center = pp;
	float blurStart = 1.0;
	uv -= center;
	float precompute = blurWidth * (1.0 / float(nsamples - 1));

	for(int i = 0; i < nsamples; i++)
	{
		float scale = blurStart + (float(i)* precompute);
		color += texture2D(bitmap, uv * scale + center);
	}

	color /= float(nsamples);

	gl_FragColor = color;
}