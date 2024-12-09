#pragma once
#include <cstddef>

#include "common/PTString.h"

constexpr auto FONT_H = 12;

class FontReader
{
	unsigned char const *pointer;
	int width;
	int pixels;
	int data;

	FontReader(unsigned char const *_pointer);
	static unsigned char const *lookupChar(PTString::value_type ch);

public:
	FontReader(PTString::value_type ch);
	int GetWidth() const;
	int NextPixel();
};
