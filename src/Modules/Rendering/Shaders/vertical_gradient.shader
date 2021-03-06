shader_type canvas_item;

uniform vec4 top_color : hint_color = vec4(1.0);
uniform vec4 bottom_color : hint_color = vec4(vec3(0.0), 1.0);

void fragment() {
	vec4 col = mix(top_color, bottom_color, UV.y);
	COLOR = col;
}