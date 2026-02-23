shader_type canvas_item;

uniform float glow_size = 2.0;
uniform vec4 glow_color : source_color = vec4(0.5,1.0,1.0,1.0);
uniform float glow_strength = 1.5;
uniform float glow_time = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float center_alpha = tex.a;
	float edge = 1.0;

	for (int x = -1; x <= 1; x++) {
		for (int y = -1; y <= 1; y++) {
			vec2 offset = vec2(float(x), float(y)) * glow_size * TEXTURE_PIXEL_SIZE;
			float a = texture(TEXTURE, UV + offset).a;

			edge += abs(center_alpha - a);
		}
	}

	edge = clamp(edge, 0.0, 1.0);

	vec4 glow = glow_color * edge * glow_strength * glow_time;

	COLOR = tex + glow;
}