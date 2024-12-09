#pragma once
#include "common/PTString.h"
#include <vector>
#include <map>
#include <memory>

namespace http
{
	class AddTagRequest;
	class RemoveTagRequest;
}

class SaveInfo;

class TagsView;
class TagsModel {
	std::shared_ptr<http::AddTagRequest> addTagRequest;
	std::shared_ptr<http::RemoveTagRequest> removeTagRequest;
	std::map<ByteString, bool> queuedTags;
	SaveInfo *save = nullptr; // non-owning
	std::vector<TagsView*> observers;
	void notifyTagsChanged();
public:
	void AddObserver(TagsView * observer);
	void SetSave(SaveInfo *newSave /* non-owning */);
	void RemoveTag(ByteString tag);
	void AddTag(ByteString tag);
	SaveInfo *GetSave(); // non-owning
	void Tick();
};
