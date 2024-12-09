#pragma once
#include <memory>
#include "common/PTString.h"
#include "common/Vec2.h"
#include "graphics/Pixel.h"
class VideoBuffer;

struct wall_type
{
	RGB<uint8_t> colour;
	RGB<uint8_t> eglow; // if emap set, add this to fire glow
	int drawstyle;
	std::shared_ptr<VideoBuffer> (*textureGen)(int, Vec2<int>);
	PTString name;
	ByteString identifier;
	PTString descs;
};
