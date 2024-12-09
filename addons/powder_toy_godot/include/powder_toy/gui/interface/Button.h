#pragma once
#include "common/PTString.h"
#include "Component.h"
#include <functional>

namespace ui
{

class Button : public Component
{
	struct ButtonAction
	{
		std::function<void ()> action, altAction, mouseEnter;
	};
	
public:
	Button(Point position = Point(0, 0), Point size = Point(0, 0), PTString buttonText = PTString(), PTString toolTip = PTString());
	virtual ~Button() = default;

	void OnMouseClick(int x, int y, unsigned int button) override;
	void OnMouseDown(int x, int y, unsigned int button) override;
	void OnMouseUp(int x, int y, unsigned int button) override;

	void OnMouseEnter(int x, int y) override;
	void OnMouseHover(int x, int y) override;
	void OnMouseLeave(int x, int y) override;

	void Draw(const Point& screenPos) override;

	void TextPosition(PTString) override;
	inline bool GetState() { return state; }
	void DoAction(); //action of button what ever it may be
	void DoAltAction(); //action of button what ever it may be
	void SetTogglable(bool isTogglable);
	bool GetTogglable();
	bool GetToggleState();
	void SetToggleState(bool state);
	inline void SetActionCallback(ButtonAction const &action) { actionCallback = action; }
	// inline ButtonAction const &GetActionCallback() const { return actionCallback; }
	void SetText(PTString buttonText);
	void SetIcon(Icon icon);
	inline PTString GetText() { return ButtonText; }
	void SetToolTip(PTString newToolTip) { toolTip = newToolTip; }

protected:
	PTString ButtonText;
	PTString toolTip;
	PTString buttonDisplayText;

	bool isButtonDown, isAltButtonDown, state, isMouseInside, isTogglable, toggle;
	ButtonAction actionCallback;
};
}
