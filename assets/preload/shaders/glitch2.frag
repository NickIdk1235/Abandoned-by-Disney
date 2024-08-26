#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

#define texture flixel_texture2D
#define fragColor gl_FragColor
#define iChannel0 bitmap
#define iTime total_time

uniform bool isActive;

// Webcam Glitch
// By Leon Denise 08-06-2022
// Simple and handy glitch effect for digital screen

vec3 hash33(vec3 p3) // Dave Hoskins https://www.shadertoy.com/view/4djSRW
{
	p3 = fract(p3 * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yxz+33.33);
	return fract((p3.xxy + p3.yxx)*p3.zyx);
}
vec2 hash21(float p)
{
	vec3 p3 = fract(vec3(p) * vec3(0.1031, 0.1030, 0.0973));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx+p3.yz)*p3.zy);
}

void main()
{
	if (!isActive) {
		gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		return;
	}

	vec2 uv = fragCoord/iResolution.xy;

	// zoom out
	//uv = (uv-0.5)*1.1+0.5;

	// animation
	float speed = 10.0;
	float t = floor(iTime*speed);

	// randomness
	vec2 lod = iResolution.xy/hash21(t)/200.0;
	vec2 p = floor(uv*lod);
	vec3 rng = hash33(vec3(p,t));

	// displace uv
	vec2 offset = vec2(cos(rng.x*6.283),sin(rng.x*6.283))*rng.y;
	float fade = sin(fract(iTime*speed)*3.1415);
	vec2 scale = 50.0 / iResolution.xy;
	float threshold = step(0.9, rng.z) ;
	uv += offset * threshold * fade * scale;

	// chromatic abberation
	vec2 rgb = 10.0/iResolution.xy * fade * threshold;
	fragColor.r = texture(iChannel0, uv+rgb).r;
	fragColor.ga = texture(iChannel0, uv).ga;
	fragColor.b = texture(iChannel0, uv-rgb).b;
	//fragColor.a = 1.0;

	// crop

	fragColor.rgb *= step(0.0,uv.x) * step(uv.x,1.0) * step(0.0,uv.y) * step(uv.y,1.0);

}