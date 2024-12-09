#pragma once
#include "common/PTString.h"
#include "ServerNotification.h"
#include <vector>
#include <optional>

struct UpdateInfo
{
	enum Channel
	{
		channelStable,
		channelBeta,
		channelSnapshot,
	};
	Channel channel;
	ByteString file;
	PTString changeLog;
	int major = 0;
	int minor = 0;
	int build = 0;
};

struct StartupInfo
{
	bool sessionGood = false;
	PTString messageOfTheDay;
	std::vector<ServerNotification> notifications;
	std::optional<UpdateInfo> updateInfo;
};
