#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define iTime total_time
// by Nikos Papadopoulos, 4rknova / 2014
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

float hash(in float n) { return fract(sin(n)*43758.5453123); }

void main()
{
	vec4 c0 = texture(iChannel0,fragCoord.xy/iResolution.xy);

	float t = pow((((1.0 + sin(iTime * 10.0) * 0.5)
		 *  0.8 + sin(iTime * cos(fragCoord.y) * 41415.92653) * 0.0125)
		 * 1.5 + sin(iTime * 7.0) * 0.5), 5.0);

	vec4 c1 = texture(iChannel0, fragCoord.xy/(iResolution.xy+vec2(t * 0.2,0.0)));
	vec4 c2 = texture(iChannel0, fragCoord.xy/(iResolution.xy+vec2(t * 0.5,0.0)));
	vec4 c3 = texture(iChannel0, fragCoord.xy/(iResolution.xy+vec2(t * 0.9,0.0)));

	float noise = hash((hash(fragCoord.x) + fragCoord.y) * iTime) * 0.055;

	fragColor = vec4(vec3(c3.r, c2.g, c1.b) + noise, c0.a);
}