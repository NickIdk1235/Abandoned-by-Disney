#pragma header

vec2 uv = openfl_TextureCoordv.xy;

const float borderWidth = 0.1;
const float gradientSmoothness = 0.1;

void main() {
	vec4 texColor = flixel_texture2D(bitmap, uv);

	// Define el ancho del borde y el suavizado del gradiente

	// Calcula la distancia al borde del sprite
	float dist = length(uv - 0.5) * 2.0;

	// Aplica el gradiente al borde
	float borderAlpha = smoothstep(borderWidth, borderWidth + gradientSmoothness, dist);

	// Mezcla el color del borde con el color del sprite
	vec4 borderColor = vec4(1.0, 1.0, 1.0, borderAlpha);
	gl_FragColor = mix(texColor, borderColor, borderAlpha);
}