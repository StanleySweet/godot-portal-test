shader_type spatial;
render_mode unshaded,diffuse_toon;
uniform vec3 FOG_COLOR : source_color; 
uniform sampler2D NOISE_TEXTURE : hint_default_black;


void fragment() {
	ALBEDO = texture(NOISE_TEXTURE,UV + vec2(0.01 * TIME)).rgb * FOG_COLOR  * 0.3;
}

