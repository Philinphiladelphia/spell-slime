#pragma once
#include "common/PTString.h"
#include <optional>

namespace Platform
{
	std::optional<ByteString> CallActivityStringFunc(const char *funcName);
}
