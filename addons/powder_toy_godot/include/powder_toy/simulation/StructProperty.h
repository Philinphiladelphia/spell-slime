#pragma once
#include "common/PTString.h"
#include <cstdint>
#include <variant>

using PropertyValue = std::variant<
	int,
	unsigned int,
	float
>;

struct StructProperty
{
	enum PropertyType
	{
		TransitionType,
		ParticleType,
		Colour,
		Integer,
		UInteger,
		Float,
		BString,
		PTString,
		UChar,
		Removed
	};
	ByteString Name;
	PropertyType Type;
	intptr_t Offset;

	StructProperty();
	StructProperty(ByteString name, PropertyType type, intptr_t offset);

	bool operator ==(const StructProperty &other) const;
	::PTString ToString(const PropertyValue &value) const;
};

struct StructPropertyAlias
{
	ByteString from, to;
};
