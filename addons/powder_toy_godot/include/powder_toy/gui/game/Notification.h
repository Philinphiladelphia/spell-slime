#pragma once
#include "common/PTString.h"

class Notification
{
public:
	Notification(PTString message) : Message(message) {}
	virtual ~Notification() {};
	PTString Message;

	virtual void Action() { }
};
