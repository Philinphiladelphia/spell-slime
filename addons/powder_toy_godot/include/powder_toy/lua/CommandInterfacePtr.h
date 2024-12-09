#pragma once
#include <memory>

class CommandInterface;
struct CommandInterfaceDeleter
{
	void operator ()(CommandInterface *ptr) const;
};
using CommandInterfacePtr = std::shared_ptr<CommandInterface>;
