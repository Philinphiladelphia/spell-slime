#pragma once
#include "common/PTString.h"
#include <memory>

class GameSave;

class SaveFile {
public:
	SaveFile(ByteString filename, bool newLazyLoad = false);

	const GameSave *LazyGetGameSave();
	const GameSave *GetGameSave() const;
	std::shared_ptr<GameSave> TakeGameSave();
	void SetGameSave(std::shared_ptr<GameSave> newSameSave);
	const PTString &GetDisplayName() const;
	void SetDisplayName(PTString displayName);
	const ByteString &GetName() const;
	void SetFileName(ByteString fileName);
	const PTString &GetError() const;
	void SetLoadingError(PTString error);

	void LazyUnload();
private:
	std::shared_ptr<GameSave> gameSave;
	ByteString filename;
	PTString displayName;
	PTString loadingError;
	bool lazyLoad;
};
