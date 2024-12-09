#pragma once
#include "common/PTString.h"
#include <exception>

struct GameModelException: public std::exception
{
	ByteString message;
public:
	GameModelException(PTString message_): message(message_.ToUtf8()) {}
	const char * what() const throw() override
	{
		return message.c_str();
	}
	~GameModelException() throw() {}
};
