shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	// Detecta solo pixels rojos: R muy dominante sobre G y B
	// barraLlena rojo = (0.835, 0, 0), barraVacia azul-claro = (0.565, 0.792, 0.976) → no afectado
	float rDominance = c.r - max(c.g, c.b);
	if (rDominance > 0.3) {
		COLOR = vec4(tint_color.rgb * c.r, c.a);
	} else {
		COLOR = c;
	}
}
