// Free for any purpose, commercial or otherwise.
// But do post here so I can see where it got used!
// If using on shadertoy, do link to this project on yours :)
#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define iTime total_time

float noise(vec2 pos, float evolve) {

	// Loop the evolution (over a very long period of time).
	float e = fract((evolve*0.01));

	// Coordinates
	float cx  = pos.x*e;
	float cy  = pos.y*e;

	// Generate a "random" black or white value
	return fract(23.0*fract(2.0/fract(fract(cx*2.4/cy*23.0+pow(abs(cy/22.4),3.3))*fract(cx*evolve/pow(abs(cy),0.050)))));
}


void main()
{
	vec3 colour = vec3(noise(fragCoord, iTime));

	fragColor = vec4(colour, texture2D(iChannel0, uv).a);
}