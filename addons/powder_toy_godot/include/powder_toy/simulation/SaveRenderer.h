#pragma once
#include <memory>
#include <mutex>
#include <utility>
#include <vector>
#include "common/ExplicitSingleton.h"
#include "graphics/RendererSettings.h"
#include "common/PTString.h"

class GameSave;
class VideoBuffer;
class Simulation;
class Renderer;

class SaveRenderer: public ExplicitSingleton<SaveRenderer>
{
	std::shared_ptr<Simulation> sim;
	std::shared_ptr<Renderer> ren;
	std::mutex renderMutex;

public:
	SaveRenderer();
	~SaveRenderer();
	std::shared_ptr<VideoBuffer> Render(const GameSave *save, bool fire, RendererSettings rendererSettings);
};
