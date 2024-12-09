#pragma once

#include "Component.h"

namespace ui
{
	class ProgressBar: public Component
	{
		int progress;
		float intermediatePos;
		PTString progressStatus;
	public:
	ProgressBar(Point position, Point size, int startProgress = 0, PTString startStatus = PTString());
		void SetProgress(int progress);
		int GetProgress();
		void SetStatus(PTString status);
		PTString GetStatus();
		void Draw(const Point & screenPos) override;
		void Tick(float dt) override;
	};
}
