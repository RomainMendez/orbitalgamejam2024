shader_type spatial;
uniform sampler2D noise;
varying vec2 tex_position;
uniform sampler2D normalmap;

void vertex() {
	//float height = texture(noise, VERTEX.xz / 2.0 + 0.5).x;
	
	tex_position = VERTEX.xz / 2.0 + 0.5;
  	float height = texture(noise, tex_position).x;
	VERTEX.y += height;
}

void fragment() {
	 //NORMAL_MAP = texture(normalmap, tex_position).xyz;
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
}
