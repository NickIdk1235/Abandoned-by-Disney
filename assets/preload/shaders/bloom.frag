#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;

uniform float amount; //default = 8.0
uniform float dim; //default = 1.8
uniform float directions; //default = 16.0
uniform float quality; //default = 4.0
uniform float size; //default = 8.0;

const float Pi = 6.28318530718;

vec4 bloom(float daAmount, float daDim, float daDir, float daQuality, float daSize)
{
	vec4 Color = texture2D(bitmap, uv);

	float ccx = (daSize + daAmount) / openfl_TextureSize.x;
	float ccy = (daSize + daAmount) / openfl_TextureSize.y;

	for (float d = 0.0; d<Pi; d += Pi / daDir) {
		vec2 rad = vec2(cos(d), sin(d));
		for (float i = 1.0/daQuality; i <=1.0; i += 1.0 / daQuality) {
			float ex = rad.x * i * ccx;
			float why = rad.y * i * ccy;
			Color += texture2D(bitmap, uv+vec2(ex, why));
		}
	}

	Color /= daAmount + (daDim * daQuality) * daDir - 15.0;
	vec4 daBloom = (texture2D(bitmap, uv) / daDim) + Color;

	return daBloom;
}

void main(void)
{
	float realAmount = amount;
	float realDim = dim;
	float realDir = directions;
	float realQuality = quality;
	float realSize = size;

	if (amount == 0.0) {
		realAmount = 8.0;
	}
	if (dim == 0.0) {
		realDim = 1.8;
	}
	if (directions == 0.0) {
		realDir = 16.0;
	}
	if (quality == 0.0) {
		realQuality = 4.0;
	}
	if (realSize == 0.0) {
		realSize = 8.0;
	}

	vec4 rah = bloom(realAmount, realDim, realDir, realQuality, realSize);
	//variable ex makes it "shine"(?)
	//variable why also makes it "shine"(?)



	gl_FragColor = rah;
}