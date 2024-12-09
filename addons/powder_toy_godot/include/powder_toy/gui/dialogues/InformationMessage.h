#pragma once
#include "gui/interface/Window.h"

class InformationMessage : public ui::Window
{
	struct DismissCallback
	{
		std::function<void ()> dismiss;
	};

	DismissCallback callback;

public:
	InformationMessage(PTString title, PTString message, bool large, DismissCallback callback_ = {});
	virtual ~InformationMessage() = default;

	void OnDraw() override;
};
