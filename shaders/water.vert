#version 400

uniform sampler2D heightMap;
uniform sampler2D waterMap;
uniform sampler2D rippleMap;
uniform mat4 vpMatrix;
uniform mat4 viewMatrix;
uniform mat4 scaleMatrix;

uniform vec2 patchPosition;
uniform vec2 patchOffset;
uniform float time;

layout (location = 0) in vec2 texCooPatch;
out vec3 normalOut;

float heightGround(vec2 tco)
{
    vec4 h = vec4(0.0);
    h = texture(heightMap, tco);
    return h.r;
}

float heightWater(vec2 tco)
{
    vec4 h = vec4(0.0);
    h = texture(waterMap, tco);
    return h.r;
}

float heightRipple(vec2 tco)
{
    vec4 h = vec4(0.0);
    h = texture(rippleMap, tco);
    return h.r;
}

float getWave(vec2 tco)
{
	return sin(tco.x*0.3-time*2.9)+sin(0.31*tco.y-time*3.0);
}

void main()
{
	vec2 texCoo;
    texCoo = patchOffset + texCooPatch;
    vec2 scaledPos = (scaleMatrix*vec4(vec2(-0.5)+texCoo, 0.0, 1.0)).xy;

	vec4 rip=texture(rippleMap,texCoo);
	float vel=rip.x;
	float amp=rip.y;

	float h=0.0;
	float hw=heightWater(texCoo);
	float hg=heightGround(texCoo);
	float factor;
	if(hw > hg) {
		float diff=(hw-hg)*10.0;
		if(diff < 0.5) {
			factor=2*diff*diff;
		} else if(diff < 1.0) {
			factor=-1.0+4.0*diff-2.0*diff*diff;
		} else {
			factor=1.0;
		}
		h=getWave(scaledPos);
		vec4 norm= vec4(h-getWave(scaledPos+vec2(0.1,0)), h-getWave(scaledPos+vec2(0,0.1)), 0.1, 1.0);
		normalOut = (norm/norm.w).xyz;
	} else normalOut=vec3(0,0,1.0);
	

    vec4 pos = vec4(scaledPos.x, -200.0 + 200.0*(hw+factor*0.01*h), scaledPos.y, 1.0);
	
	gl_Position = vpMatrix * pos;
}

