#pragma once
#include "graphics/Pixel.h"
#include "common/PTString.h"

struct CustomGOLData
{
	int rule;
	RGB<uint8_t> colour1, colour2;
	PTString nameString;

	inline bool operator <(const CustomGOLData &other) const
	{
		return rule < other.rule;
	}
};
