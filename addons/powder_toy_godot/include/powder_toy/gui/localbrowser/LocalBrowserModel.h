#pragma once
#include "common/PTString.h"
#include <vector>
#include <memory>

class SaveFile;

class LocalBrowserView;
class LocalBrowserModel {
	std::vector<ByteString> selected;
	std::shared_ptr<SaveFile> stamp;
	std::vector<ByteString> stampIDs;
	std::vector<std::shared_ptr<SaveFile>> savesList;
	std::vector<LocalBrowserView*> observers;
	int currentPage = 0;
	bool stampToFront = true;
	void notifySavesListChanged();
	void notifyPageChanged();
	void notifySelectedChanged();
public:
	LocalBrowserModel();
	int GetPageCount();
	int GetPageNum() { return currentPage; }
	void AddObserver(LocalBrowserView * observer);
	std::vector<SaveFile *> GetSavesList(); // non-owning
	void UpdateSavesList(int pageNumber);
	void RescanStamps();
	const SaveFile *GetSave();
	std::shared_ptr<SaveFile> TakeSave();
	void OpenSave(int index);
	bool GetMoveToFront();
	void SetMoveToFront(bool move);
	std::vector<ByteString> GetSelected() { return selected; }
	void ClearSelected() { selected.clear(); notifySelectedChanged(); }
	void SelectSave(ByteString stampID);
	void DeselectSave(ByteString stampID);
};
