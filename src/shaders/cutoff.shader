shader_type canvas_item;

uniform float value :hint_range(0.255, 0.8) = 0.5;
uniform vec2 texSize;

void fragment() {
	vec2 uv = vec2(mod((texSize + vec2(6.0, 3.0)) * UV, 17.0)) / 17.0;
	float a = 1.0;
	if (uv.x + (1.0 - uv.y) > value * 2.0) {
		a = 0.0;
	}
	vec4 tex = texture(TEXTURE, UV);
	COLOR = vec4(tex.rgb, min(a, tex.a));
}