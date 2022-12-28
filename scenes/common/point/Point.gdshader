shader_type spatial;
render_mode shadows_disabled;

uniform float metallic : hint_range(0, 1);
uniform float roughness : hint_range(0,1);

//varying vec4 world_vertex;
void vertex() {
	
}

void fragment() {
	METALLIC = metallic;
	ROUGHNESS = roughness;
	
//	ALBEDO = vec3(color.x, color.y, color.z);
	// pixel's position in object space
	// only set the rg color so we remove z blue component
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	ALBEDO.rgb = world_vertex.xyz * 0.5 + 0.5;
	ALPHA = 1.0;
}
