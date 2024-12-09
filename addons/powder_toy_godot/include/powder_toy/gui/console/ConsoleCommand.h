#pragma once
#include "common/PTString.h"

class ConsoleCommand
{
public:
	ConsoleCommand(PTString command, int returnStatus, PTString returnValue):
		Command(command), ReturnStatus(returnStatus), ReturnValue(returnValue)
	{

	}
	PTString Command;
	int ReturnStatus;
	PTString ReturnValue;

	operator PTString() const
	{
		return Command;
	}
};

