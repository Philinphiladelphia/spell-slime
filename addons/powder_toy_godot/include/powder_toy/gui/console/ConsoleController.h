#pragma once
#include "common/PTString.h"
#include <functional>

class CommandInterface;
class ConsoleModel;
class ConsoleView;
class ConsoleController
{
	ConsoleView * consoleView;
	ConsoleModel * consoleModel;
	CommandInterface * commandInterface;
	std::function<void ()> onDone;
public:
	bool HasDone;
	ConsoleController(std::function<void ()> onDone, CommandInterface * commandInterface);
	PTString FormatCommand(PTString command);
	void EvaluateCommand(PTString command);
	void NextCommand();
	void PreviousCommand();
	void Exit();
	void CloseConsole();
	ConsoleView * GetView();
	virtual ~ConsoleController();
};
