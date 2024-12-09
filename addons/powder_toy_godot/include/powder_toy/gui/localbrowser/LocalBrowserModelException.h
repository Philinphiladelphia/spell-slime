#pragma once
#include "common/PTString.h"
#include <exception>

class LocalBrowserModelException : std::exception
{
	ByteString message;
public:
	LocalBrowserModelException(PTString message_): message(message_.ToUtf8()) {};
	const char * what() const throw() { return message.c_str(); };
	~LocalBrowserModelException() throw() {};
};
