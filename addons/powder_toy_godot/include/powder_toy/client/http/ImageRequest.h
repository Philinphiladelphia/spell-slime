#pragma once
#include "common/PTString.h"
#include "common/Vec2.h"
#include "Request.h"
#include <memory>

class VideoBuffer;

namespace http
{
	class ImageRequest : public Request
	{
		Vec2<int> requestedSize;

	public:
		ImageRequest(ByteString url, Vec2<int> newRequestedSize);

		std::shared_ptr<VideoBuffer> Finish();
	};
}
