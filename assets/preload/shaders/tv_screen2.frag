// https://www.shadertoy.com/view/lt3yz7

#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv * openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

#define texture flixel_texture2D
#define fragColor gl_FragColor
#define iChannel0 bitmap
#define iTime total_time

uniform bool isActive;
uniform bool GLITCH;
uniform bool force;

float rand(float seed){
	return fract(sin(dot(vec2(seed) ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 displace(vec2 co, float seed, float seed2) {
	vec2 shift = vec2(0.0);
	if (rand(seed) > 0.5) {
		shift += 0.1 * vec2(2.0 * (0.5 - rand(seed2)));
	}
	if (rand(seed2) > 0.6) {
		if (co.y > 0.5) {
			shift.x *= rand(seed2 * seed);
		}
	}
	return shift;
}

vec4 interlace(vec2 co, vec4 col) {
	if(mod(floor(co.y), 3.0) == 0.0) {
		return col * ((sin(iTime * 4.0) * 0.1) + 0.75) + (rand(iTime) * 0.05);
	}
	return col;
}

void main()
{
	if (!isActive && !force) {
		gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		return;
	}

	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = fragCoord/iResolution.xy;

	vec2 rDisplace = vec2(0.0);
	vec2 gDisplace = vec2(0.0);
	vec2 bDisplace = vec2(0.0);

	if (GLITCH) {
		rDisplace = displace(uv, iTime * 2.0, 2.0 + iTime);
		gDisplace = displace(uv, iTime * 3.0, 3.0 + iTime);
		bDisplace = displace(uv, iTime * 5.0, 5.0 + iTime);
	}

	rDisplace.x += 0.005 * (0.5 - rand(iTime * 37.0 * uv.y));
	gDisplace.x += 0.007 * (0.5 - rand(iTime * 41.0 * uv.y));
	bDisplace.x += 0.0011 * (0.5 - rand(iTime * 53.0 * uv.y));

	rDisplace.y += 0.001 * (0.5 - rand(iTime * 37.0 * uv.x));
	gDisplace.y += 0.001 * (0.5 - rand(iTime * 41.0 * uv.x));
	bDisplace.y += 0.001 * (0.5 - rand(iTime * 53.0 * uv.x));

	// Output to screen
	float rcolor = texture(iChannel0, uv.xy + rDisplace).r;
	float gcolor = texture(iChannel0, uv.xy + gDisplace).g;
	float bcolor = texture(iChannel0, uv.xy + bDisplace).b;
	float acolor = texture(iChannel0, uv.xy).a;

	fragColor = interlace(fragCoord, vec4(rcolor, gcolor, bcolor, acolor));
}