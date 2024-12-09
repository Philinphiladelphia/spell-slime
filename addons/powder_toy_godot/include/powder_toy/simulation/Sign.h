#pragma once
#include "common/PTString.h"
#include <utility>

struct RenderableSimulation;

struct sign
{
	enum Justification
	{
		Left,
		Middle,
		Right,
		None,
		Max,
	};

	enum Type
	{
		Normal,
		Save,
		Thread,
		Button,
		Search
	};

	int x, y;
	Justification ju;
	PTString text;

	sign(PTString text_, int x_, int y_, Justification justification_);
	PTString getDisplayText(const RenderableSimulation *sim, int &x, int &y, int &w, int &h, bool colorize = true, bool *v95 = nullptr) const;
	std::pair<int, Type> split() const;
};
