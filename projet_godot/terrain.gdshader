shader_type spatial;
uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
	float height = texture(noise, VERTEX.xz / 0.5 + 0.5).x;
	VERTEX.y += height;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
