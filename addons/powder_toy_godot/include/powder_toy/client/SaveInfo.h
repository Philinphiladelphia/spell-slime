#pragma once
#include "common/PTString.h"
#include <list>
#include <memory>
#include <ctime>

class GameSave;

class SaveInfo
{
private:
public:
	int id;
	time_t createdDate;
	time_t updatedDate;
	int votesUp, votesDown;
	int vote;
	bool Favourite;
	int Comments;
	int Views;
	int Version;

	ByteString userName;

	PTString name;
	PTString Description;
	bool Published;

	std::list<ByteString> tags;
	std::shared_ptr<GameSave> gameSave;

	SaveInfo(int _id, time_t _createdDate, time_t _updatedDate, int _votesUp, int _votesDown, ByteString _userName, PTString _name);

	SaveInfo(int _id, time_t _createdDate, time_t _updatedDate, int _votesUp, int _votesDown, int _vote, ByteString _userName, PTString _name, PTString description_, bool published_, std::list<ByteString> tags);

	void SetName(PTString name);
	const PTString &GetName() const;

	void SetDescription(PTString description);
	const PTString &GetDescription() const;

	void SetPublished(bool published);
	bool GetPublished() const;

	void SetUserName(ByteString userName);
	const ByteString &GetUserName() const;

	void SetID(int id);
	int GetID() const;

	void SetVote(int vote);
	int GetVote() const;

	void SetVotesUp(int votesUp);
	int GetVotesUp() const;

	void SetVotesDown(int votesDown);
	int GetVotesDown() const;

	void SetVersion(int version);
	int GetVersion() const;

	void SetTags(std::list<ByteString> tags);
	std::list<ByteString> GetTags() const;

	const GameSave *GetGameSave() const;
	std::shared_ptr<GameSave> TakeGameSave();
	void SetGameSave(std::shared_ptr<GameSave> newGameSave);

	std::shared_ptr<SaveInfo> CloneInfo() const;
};
