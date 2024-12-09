#pragma once
#include "common/PTString.h"
#include <vector>

class GameModel;
class QuickOption;
class QuickOptionListener
{
protected:
	QuickOptionListener() {}
public:
	virtual ~QuickOptionListener() {}
	virtual void OnValueChanged(QuickOption * sender) {}
};
class QuickOption
{
public:
	enum Type {
		Toggle, Multi
	};
protected:
	std::vector<QuickOptionListener*> listeners;
	GameModel * m;
	Type type;
	PTString icon;
	PTString description;
	QuickOption(PTString icon, PTString description, GameModel * m, Type type) :
		m(m),
		type(type),
		icon(icon),
		description(description)
	{

	}
	virtual void perform() {}
public:
	virtual ~QuickOption()
	{
		for(std::vector<QuickOptionListener*>::iterator iter = listeners.begin(), end = listeners.end(); iter != end; ++iter)
			delete *iter;
	}

	std::vector<QuickOptionListener*> GetListeners()
	{
		return listeners;
	}

	void AddListener(QuickOptionListener * listener)
	{
		listeners.push_back(listener);
	}

	Type GetType() { return type; }

	virtual bool GetToggle() { return true;}
	virtual int GetMutli() { return 0;}
	virtual int GetMultiCount() { return 0;}

	PTString GetIcon() { return icon; }
	void SetIcon(PTString icon) { this->icon = icon; }
	PTString GetDescription() { return description; }
	void SetDescription(PTString description) { this->description = description; }
	void Perform()
	{
		perform();
		for(std::vector<QuickOptionListener*>::iterator iter = listeners.begin(), end = listeners.end(); iter != end; ++iter)
			(*iter)->OnValueChanged(this);
	}
	void Update()
	{
		for(std::vector<QuickOptionListener*>::iterator iter = listeners.begin(), end = listeners.end(); iter != end; ++iter)
			(*iter)->OnValueChanged(this);
	}
};

