#pragma once
#include "common/PTString.h"
#include "client/Comment.h"
#include <vector>
#include <memory>
#include <optional>

namespace http
{
	class GetSaveDataRequest;
	class GetSaveRequest;
	class GetCommentsRequest;
	class FavouriteSaveRequest;
}

class PreviewView;
class SaveInfo;
class PreviewModel
{
	bool doOpen = false;
	bool fromUrl = false;
	bool canOpen = true;
	std::vector<PreviewView*> observers;
	std::shared_ptr<SaveInfo> saveInfo;
	std::optional<std::vector<char>> saveData;
	std::optional<std::vector<Comment>> saveComments;
	void notifySaveChanged();
	void notifySaveCommentsChanged();
	void notifyCommentsPageChanged();
	void notifyCommentBoxEnabledChanged();

	std::shared_ptr<http::GetSaveDataRequest> saveDataDownload;
	std::shared_ptr<http::GetSaveRequest> saveInfoDownload;
	std::shared_ptr<http::GetCommentsRequest> commentsDownload;
	std::shared_ptr<http::FavouriteSaveRequest> favouriteSaveRequest;
	int saveID;
	int saveDate;

	bool commentBoxEnabled = false;
	bool commentsLoaded = false;
	int commentsTotal = 0;
	int commentsPageNumber = 1;

	std::optional<bool> queuedFavourite;

public:
	const SaveInfo *GetSaveInfo() const;
	std::shared_ptr<SaveInfo> TakeSaveInfo();
	const std::vector<Comment> *GetComments() const
	{
		return saveComments ? &*saveComments : nullptr;
	}

	bool GetCommentBoxEnabled();
	void SetCommentBoxEnabled(bool enabledState);

	bool GetCommentsLoaded();
	int GetCommentsPageNum();
	int GetCommentsPageCount();
	void UpdateComments(int pageNumber);
	void CommentAdded();

	void AddObserver(PreviewView * observer);
	void UpdateSave(int saveID, int saveDate);
	void SetFavourite(bool favourite);
	bool GetDoOpen();
	bool GetFromUrl();
	bool GetCanOpen();
	void SetDoOpen(bool doOpen);
	void SetFromUrl(bool fromUrl);
	void Update();
	void OnSaveReady();
	bool ParseSaveInfo(ByteString &saveInfoResponse);
	bool ParseComments(ByteString &commentsResponse);
};
