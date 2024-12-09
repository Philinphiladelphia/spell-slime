#pragma once
#include "common/PTString.h"
#include <vector>
#include <variant>
#include <memory>
#include <optional>

class GameSave;

namespace Clipboard
{
	class ClipboardImpl
	{
	public:
		virtual ~ClipboardImpl() = default;

		virtual void SetClipboardData() = 0;

		struct GetClipboardDataUnchanged
		{
		};
		struct GetClipboardDataChanged
		{
			std::vector<char> data;
		};
		struct GetClipboardDataFailed
		{
		};
		struct GetClipboardDataUnknown
		{
		};
		using GetClipboardDataResult = std::variant<
			GetClipboardDataUnchanged,
			GetClipboardDataChanged,
			GetClipboardDataFailed,
			GetClipboardDataUnknown
		>;
		virtual GetClipboardDataResult GetClipboardData() = 0;

		virtual std::optional<PTString> Explanation() = 0;
	};

	extern std::shared_ptr<GameSave> clipboardData;

	void SerializeClipboard(std::vector<char> &saveData);

	extern int currentSubsystem;
}
