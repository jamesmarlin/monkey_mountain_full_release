shader_type canvas_item;

uniform bool death = false;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	// Calculate the grayscale luminance (weighted for human eye perception)
	float gray = dot(original_color.rgb, vec3(0.299, 0.587, 0.114));
	
	if (death) {
		// Apply the grayscale to RGB and keep the original transparency (Alpha)
		COLOR = vec4(vec3(gray), original_color.a);	
	}
}