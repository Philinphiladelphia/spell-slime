#pragma once
#include "common/PTString.h"

class Tool;
class Menu
{
	PTString::value_type icon;
	PTString description;
	std::vector<Tool*> tools;
	bool visible;
public:
	Menu(PTString::value_type icon_, PTString description_, int visible_);
	virtual ~Menu();

	std::vector<Tool*> GetToolList()
	{
		return tools;
	}

	PTString::value_type GetIcon()
	{
		return icon;
	}

	PTString GetDescription()
	{
		return description;
	}

	bool GetVisible()
	{
		return visible;
	}

	void AddTool(Tool * tool_);
	void ClearTools();
};

