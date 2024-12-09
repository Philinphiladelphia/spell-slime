#ifndef POWDER_TOY_INTERFACE_H
#define POWDER_TOY_INTERFACE_H

#include <deque>
#include <chrono>
#include <mutex>
#include <vector>

// Powder Toy Imports
#include "simulation/Simulation.h"
#include "gui/game/GameModel.h"

// Singleton imports
#include "prefs/GlobalPrefs.h"
#include "client/Client.h"
#include "client/http/requestmanager/RequestManager.h"
#include "common/platform/Platform.h"
#include "graphics/Graphics.h"
#include "simulation/SaveRenderer.h"
#include "simulation/SimulationData.h"
#include "common/tpt-rand.h"
#include "gui/game/Favorite.h"
#include "gui/game/GameController.h"
#include "gui/game/GameView.h"
#include "gui/interface/Engine.h"
#include "SimulationConfig.h"

struct ExplicitSingletons
{
	// These need to be listed in the order they are populated in main.
	std::unique_ptr<GlobalPrefs> globalPrefs;
	http::RequestManagerPtr requestManager;
	std::unique_ptr<Client> client;
	std::unique_ptr<SaveRenderer> saveRenderer;
	std::unique_ptr<Favorite> favorite;
	std::unique_ptr<ui::Engine> engine;
	std::unique_ptr<SimulationData> simulationData;
	std::unique_ptr<GameController> gameController;
    std::unique_ptr<Simulation> simulation;
};

struct PowderCircle
{
    int x;
    int y;
    int r;
    int type;
};

struct PowderLine
{
    int x1;
    int y1;
    int x2;
    int y2;
    int r;
    int type;
};

class PowderToyInterface {
public:
    PowderToyInterface();

    void SetPrettyPowder(int prettyPowder);
    void SetSimEdgeMode(int edgeMode);
    void SetSimGravMode(int gravMode);
    void SetCustomGravity(float x, float y);

    void ClearArea(int x, int y, int w, int h);

    // Powder creation functions
    void MakeCircle(PowderCircle &circle);
    void MakeLine(PowderLine &line);
    void MakePowderBox(int x, int y, int w, int h, int type);
    void FloodPowder(int x, int y, int type, int bitmask);

    void ClearSim();

    void MakeWall(PowderCircle &circle);
    void MakeWallLine(PowderLine &line);
    void MakeWallBox(int x, int y, int w, int h, int type);
    void FloodWalls(int x, int y, int type, int bitmask);

    bool RequestsBuffered();
    void SetSimFramerate(int framerate);
    void SetSimDrawingFrequency(int frequency);
    void RunSimFrame();

    void GetWalls(int* walls);
    void GetParticles(int* particles);
    void GetParticleColors(int* particle_colors);

    void InitializeSingletons();

private:

    std::unique_ptr<ExplicitSingletons> explicit_singletons_;
};

#endif // POWDER_TOY_INTERFACE_H