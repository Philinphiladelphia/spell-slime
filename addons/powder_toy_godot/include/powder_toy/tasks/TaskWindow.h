#pragma once
#include "gui/interface/Window.h"
#include "tasks/TaskListener.h"
#include <memory>

namespace ui
{
	class Label;
	class ProgressBar;
}

class Task;
class TaskWindow: public ui::Window, public TaskListener {
	std::shared_ptr<Task> task;
	PTString title;
	int progress;
	float intermediatePos;
	bool done;
	bool closeOnDone;
	ui::Label *statusLabel{};
	ui::ProgressBar *progressBar{};
	PTString progressStatus;
public:
	TaskWindow(PTString title_, Task * task_, bool closeOnDone = true);
	void NotifyStatus(Task * task) override;
	void NotifyDone(Task * task) override;
	void NotifyProgress(Task * task) override;
	void NotifyError(Task * task) override;
	void OnTick(float dt) override;
	void OnDraw() override;
	void Exit();
};
