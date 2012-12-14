#version 400

uniform sampler2D heightMap;
uniform mat4 vpMatrix;
uniform mat4 viewMatrix;
uniform mat4 scaleMatrix;

uniform vec3 lightSource;
uniform vec2 patchPosition;
uniform vec2 patchOffset;

layout (location = 0) in vec2 texCooPatch;
out vec2 texCoo;
out vec4 posOut;
out vec3 normalOut;
out vec3 lightSrc;
out float spec;
float height(vec2 tco)
{
    vec4 h = vec4(0.0);
    h = texture(heightMap, tco);
    return h.r;
}

void main()
{
    texCoo = patchOffset + texCooPatch;
    vec2 scaledPos = (scaleMatrix*vec4(vec2(-0.5)+texCoo, 0.0, 1.0)).xy;
    vec4 pos = vec4(scaledPos.x, -200.0 + 200.0*height(texCoo), scaledPos.y, 1.0);

    float textureDelta = 1.0/512.0;
    float A = height(texCoo + vec2(0.0,textureDelta));
    float B = height(texCoo + vec2(textureDelta,0.0));
    float C = height(texCoo + vec2(0.0,-textureDelta));
    float D = height(texCoo + vec2(-textureDelta,0.0));

    vec4 normal = vec4( (D-B), 2.0/200.0, (C-A), 0.0 );
    normalOut = normalize( normal.xyz );

	vec4 norm=normalize(viewMatrix*vec4(normal.xyz,0.0));
	vec4 light=viewMatrix*vec4(lightSource.xyz,0.0);
	vec4 reflection=2.0*norm*dot(light,norm)-light;
	spec=max(dot(reflection,-1.0*normalize(viewMatrix*pos)),0);
	//spec=dot(norm,norm);

    gl_Position = vpMatrix * pos;
    posOut = pos;
	lightSrc=lightSource;
}

