shader_type canvas_item;

uniform vec4 top_color : hint_color = vec4(1.0);
uniform vec4 bottom_color : hint_color = vec4(vec3(0.0), 1.0);

uniform float transparent_edge_amount :hint_range(0.0, 0.5) = 0.0;

void fragment() {
	vec4 col = mix(top_color, bottom_color, UV.y);
	
	// TEA
	float tea = transparent_edge_amount;
	if (UV.x < tea || UV.x > tea || UV.y < tea || UV.y > tea) {
		
	}
		
	COLOR = col;
}