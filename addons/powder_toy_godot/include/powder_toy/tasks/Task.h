#pragma once
#include "common/PTString.h"
#include <thread>
#include <mutex>

class TaskListener;
class Task {
public:
	void AddTaskListener(TaskListener * listener);
	virtual void Start();
	int GetProgress();
	bool GetDone();
	bool GetSuccess();
	PTString GetError();
	PTString GetStatus();
	virtual void Poll();
	Task();
	virtual ~Task();

protected:
	int progress;
	bool done;
	bool success;
	PTString status;
	PTString error;

	int thProgress;
	bool thDone;
	bool thSuccess;
	PTString thStatus;
	PTString thError;

	TaskListener *listener;
	std::mutex taskMutex;

	virtual void before();
	virtual void after();
	virtual bool doWork();
	virtual void doWork_wrapper();

	virtual void notifyProgress(int progress);
	virtual void notifyError(PTString error);
	virtual void notifyStatus(PTString status);

	virtual void notifyProgressMain();
	virtual void notifyErrorMain();
	virtual void notifyStatusMain();
	virtual void notifyDoneMain();
};
