#pragma once
#include "common/PTString.h"
#include <cstdint>

struct RenderPreset
{
	PTString Name;
	uint32_t renderMode;
	uint32_t displayMode;
	uint32_t colorMode;
};
