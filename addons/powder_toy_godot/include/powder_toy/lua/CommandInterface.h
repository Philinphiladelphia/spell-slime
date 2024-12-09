#pragma once
#include "CommandInterfacePtr.h"
#include "common/ExplicitSingleton.h"
#include "common/PTString.h"
#include "gui/game/GameControllerEvents.h"
#include "TPTSTypes.h"
#include <deque>
#include <optional>

class GameModel;
class GameController;
class Tool;

class CommandInterface : public ExplicitSingleton<CommandInterface>
{
protected:
	PTString lastError;
	GameModel * m;
	GameController * c;


	int PlainCommand(PTString command);
	PTString PlainFormatCommand(PTString command);

public:
	CommandInterface(GameController *newGameController, GameModel *newGameModel);

	enum LogType { LogError, LogWarning, LogNotice };
	enum FormatType { FormatInt, FormatString, FormatChar, FormatFloat, FormatElement };
	void Log(LogType type, PTString message);
	//void AttachGameModel(GameModel * m);

	void OnTick();
	void Init();

	bool HandleEvent(const GameControllerEvent &event);
	bool HaveSimGraphicsEventHandlers();

	int Command(PTString command);
	PTString FormatCommand(PTString command);
	void SetLastError(PTString err)
	{
		lastError = err;
	}
	PTString GetLastError();

	AnyType eval(std::deque<PTString> * words);
	int parseNumber(PTString str);
	AnyType tptS_set(std::deque<PTString> * words);
	AnyType tptS_get(std::deque<PTString> * words);
	AnyType tptS_create(std::deque<PTString> * words);
	AnyType tptS_delete(std::deque<PTString> * words);
	AnyType tptS_load(std::deque<PTString> * words);
	AnyType tptS_reset(std::deque<PTString> * words);
	AnyType tptS_bubble(std::deque<PTString> * words);
	AnyType tptS_quit(std::deque<PTString> * words);
	ValueType testType(PTString word);

	void SetToolIndex(ByteString identifier, std::optional<int> index);

	static CommandInterfacePtr Create(GameController *newGameController, GameModel *newGameModel);
};
