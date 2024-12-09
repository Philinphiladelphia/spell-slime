#pragma once
#include <memory>

struct fftwf_plan_s {};

class Gravity;
struct GravityDeleter
{
	void operator ()(Gravity *ptr) const;
};
using GravityPtr = std::shared_ptr<Gravity>;
