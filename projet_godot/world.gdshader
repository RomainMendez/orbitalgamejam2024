shader_type spatial;
uniform float height_scale = 1.0;
uniform sampler2D noise;
uniform sampler2D normalmap;

varying vec2 tex_position;

void vertex() {
  float height = texture(noise, VERTEX.xz / 2.0 + 0.5).x;
  VERTEX.y += height;
}

void fragment() {
  //NORMAL_MAP = texture(normalmap, tex_position).xyz;
  //METALLIC = 0.0;
  //ROUGHNESS = 0.01;
  ALBEDO = vec3(0.0, 0.25, 0.08);
}