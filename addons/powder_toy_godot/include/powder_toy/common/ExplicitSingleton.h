#pragma once
#include <cassert>

template<class Type>
class ExplicitSingleton // not anymore lol
{
	static Type *&Instance()
	{
		// [dcl.fct.spec]: A static local variable in an extern inline function always refers to the same object.
		static Type *instance = nullptr;
		return instance;
	}

public:
	ExplicitSingleton()
	{
		auto &instance = Instance();
		//assert(!instance);  singleton be gone
		instance = static_cast<Type *>(this);
	}

	~ExplicitSingleton()
	{
		Instance() = nullptr;
	}

	static Type &Ref()
	{
		return *Instance();
	}

	static const Type &CRef()
	{
		return Ref();
	}
};
