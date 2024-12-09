#pragma once
#include "common/PTString.h"
#include "Component.h"
#include <functional>

namespace ui
{
class Checkbox: public ui::Component {
	PTString text;
	PTString toolTip;
	bool checked;
	bool isMouseOver;
	struct CheckboxAction
	{
		std::function<void ()> action;
	};
	CheckboxAction actionCallback;

public:
	Checkbox(ui::Point position, ui::Point size, PTString text, PTString toolTip);
	virtual ~Checkbox() = default;
	
	void SetText(PTString text);
	PTString GetText();
	void SetIcon(Icon icon);
	void Draw(const Point& screenPos) override;
	void OnMouseEnter(int x, int y) override;
	void OnMouseHover(int x, int y) override;
	void OnMouseLeave(int x, int y) override;
	void OnMouseClick(int x, int y, unsigned int button) override;
	void OnMouseUp(int x, int y, unsigned int button) override;
	inline void SetActionCallback(CheckboxAction const &action) { actionCallback = action; }
	inline CheckboxAction const &GetActionCallback() const { return actionCallback; }
	bool GetChecked() { return checked; }
	void SetChecked(bool checked_) { checked = checked_; }
};
}
