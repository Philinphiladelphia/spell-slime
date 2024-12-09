#pragma once
#include "gui/interface/Window.h"

#include <functional>

class ErrorMessage : public ui::Window
{
	struct DismissCallback
	{
		std::function<void ()> dismiss;
	};

	DismissCallback callback;

public:
	ErrorMessage(PTString title, PTString message, DismissCallback callback_ = {});
	virtual ~ErrorMessage() = default;

	void OnDraw() override;
};
