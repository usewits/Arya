#version 400

uniform sampler2D clouds;
uniform sampler2D stars;
uniform float time;

in vec3 normalVector;
in vec2 texCoord;

in float spec;
in float depth;

out vec4 FragColor;

vec4 terrainColor(vec2 tex, float dayFactor, float cloudyness)
{
	tex=tex-time*0.01*vec2(.3, .4);
	vec2 pos=3.*(tex-.001*normalVector.xz);
	vec4 texCloud=texture(clouds, pos);
    return (0.2+dayFactor*0.8)*texCloud*(texCloud.a*cloudyness)+(1.0-texCloud.a*cloudyness)*(1.0-dayFactor)*texture(stars, pos);
}

void main()
{
	float dayFactor=0.0;//[0,1], 0=midnight, 1=midday
	float cloudyness=1.0;//[0,1], 0=clear sky, 1= cloudy sky
	
	
	float refFact=0.1*pow(spec,0.2)+0.2*pow(spec,2.0)+10.0*pow(spec,100.0);
	vec4 terCol=terrainColor(texCoord,dayFactor, cloudyness);
	vec3 waterColor=0.4*terCol.xyz+dayFactor*vec3(0.085882, 0.12549, 0.487255);
	if(0.2+min(10.0*depth,1.0) < .1) discard;
	FragColor=vec4(waterColor, 0.2+min(10.0*depth,1.0))+refFact*vec4(waterColor, 0);
}
