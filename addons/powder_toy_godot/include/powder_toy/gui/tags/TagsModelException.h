#pragma once
#include "common/PTString.h"
#include <exception>

class TagsModelException : public std::exception {
	ByteString message;
public:
	TagsModelException(PTString message): message(message.ToUtf8()) {};
	const char * what() const throw() override { return message.c_str(); };
	~TagsModelException() throw() {};
};
