#pragma once

#include "common/PTString.h"
#include <exception>

bool ValidateGOLName(const PTString &value);
int ParseGOLString(const PTString &value);
PTString SerialiseGOLRule(int rule);
