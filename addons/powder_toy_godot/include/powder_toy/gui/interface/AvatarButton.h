#pragma once
#include "common/PTString.h"

#include "Component.h"
#include "graphics/Graphics.h"
#include "gui/interface/Colour.h"
#include "client/http/ImageRequest.h"

#include <memory>
#include <functional>

namespace ui
{
class AvatarButton : public Component
{
	std::shared_ptr<VideoBuffer> avatar;
	ByteString name;
	bool tried;

	struct AvatarButtonAction
	{
		std::function<void ()> action;
	};
	AvatarButtonAction actionCallback;

	std::shared_ptr<http::ImageRequest> imageRequest;

public:
	AvatarButton(Point position, Point size, ByteString username);
	virtual ~AvatarButton() = default;

	void OnMouseClick(int x, int y, unsigned int button) override;
	void OnMouseDown(int x, int y, unsigned int button) override;

	void OnMouseEnter(int x, int y) override;
	void OnMouseLeave(int x, int y) override;

	void OnContextMenuAction(int item) override;

	void Draw(const Point& screenPos) override;
	void Tick(float dt) override;

	void DoAction();

	void SetUsername(ByteString username) { name = username; }
	ByteString GetUsername() { return name; }
	inline void SetActionCallback(AvatarButtonAction const &action) { actionCallback = action; };
protected:
	bool isMouseInside, isButtonDown;
};
}
