#pragma once
#include "gui/interface/Window.h"

#include <functional>

namespace ui
{
	class Textbox;
}

class TextPrompt : public ui::Window
{
	struct TextDialogueCallback
	{
		std::function<void (PTString const &)> text;
		std::function<void ()> cancel;
	};

	TextDialogueCallback callback;

protected:
	ui::Textbox * textField;

public:
	TextPrompt(PTString title, PTString message, PTString text, PTString placeholder, bool multiline, TextDialogueCallback callback_ = {});
	virtual ~TextPrompt() = default;

	void OnDraw() override;
};
