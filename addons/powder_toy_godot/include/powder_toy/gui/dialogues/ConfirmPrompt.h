#pragma once
#include "gui/interface/Window.h"

#include <functional>

class ConfirmPrompt : public ui::Window
{
	struct ResultCallback
	{
		std::function<void ()> okay, cancel;
	};

	ResultCallback callback;

public:
	ConfirmPrompt(PTString title, PTString message, ResultCallback callback_ = {}, PTString buttonText = PTString("Confirm"));
	virtual ~ConfirmPrompt() = default;

	void OnDraw() override;
};
