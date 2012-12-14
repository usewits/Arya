#pragma once

#include <vector>
using std::vector;

namespace Arya
{
    class Terrain;
    class Camera;
    class Texture;
    class Scene;

    class Map
    {
        public:
            Map();
            ~Map();

            bool init(const char* hm, const char* wm, vector<Texture*> ts, Texture* sm);

            bool setTerrain(const char* hm, const char* wm, vector<Texture*> ts, Texture* sm);
            void render(Camera* cam);
            void update(float elapsedTime, Scene* scene);

        private:
            Terrain* terrain;
    };
}
