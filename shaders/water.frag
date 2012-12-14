#version 400

out vec4 FragColor;

in vec3 normalOut;

void main()
{
	vec3 lighting=vec3(0.7, 0.7, 0.0);
	float prod=1.0*dot(normalOut,vec3(1.0,1.0,0.0));

	FragColor=vec4(prod, prod, prod+0.7, 0.5);
}
