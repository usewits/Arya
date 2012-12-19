#pragma once

#include <glm/glm.hpp>
#include <vector>
#include "Textures.h"

using glm::vec2;
using glm::vec3;
using glm::vec4;
using glm::mat4;
using std::vector;

namespace Arya
{
    class Weather
    {
        public:
            Weather();
            ~Weather();

			vec3 lightDirection;	//pointing from the source
			vec4 lightColor;		//lightColor.a is the light intensity

			vec2 windDirection;
			float windIntesity;

			vector<Texture*> skyTextures;
			vector<float> getBlend();

        private:
			float time;				//[0,1], The time, 0=midnight, .5=midday, 1=midnight
			float dayFactor;		//[0,1], 0=midnight, 1=midday
			float cloudFactor;		//[0,1], 0=clear sky, 1=cloudy sky
			float rainFactor;		//[0,1], 0=dry, 1=rain
			float lightningFactor;	//[0,1], 0=no lightning, 1=lots of lightning
            
    };

}
