shader_type spatial;
render_mode blend_mix,depth_draw_opaque,diffuse_burley,specular_schlick_ggx,vertex_lighting;

uniform vec4 grass : source_color;
uniform vec4 dirt: source_color;
uniform vec4 rock : source_color;

varying vec4 color;
void vertex() {
	color = grass;
	NORMAL = NORMAL;
	
	if(dot(NORMAL,vec3(0,1,0)) < 0.4) {
		color = dirt;
	} 
	
	if(dot(NORMAL,vec3(0,1,0)) < -0.6) {
		color = rock;
	}
}

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = color.rgb;
}
