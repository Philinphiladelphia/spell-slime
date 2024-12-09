#pragma once
#include "common/Vec2.h"
#include "tasks/AbandonableTask.h"
#include "graphics/RendererSettings.h"

#include <memory>

class GameSave;
class VideoBuffer;
class ThumbnailRendererTask : public AbandonableTask
{
	std::shared_ptr<GameSave> save;
	Vec2<int> size;
	RendererSettings::DecorationLevel decorationLevel;
	bool fire;
	std::shared_ptr<VideoBuffer> thumbnail;

	static int queueSize;

public:
	ThumbnailRendererTask(GameSave const &, Vec2<int> size, RendererSettings::DecorationLevel newDecorationLevel, bool fire);
	virtual ~ThumbnailRendererTask();

	virtual bool doWork() override;
	std::shared_ptr<VideoBuffer> Finish();

	static int QueueSize();
};
