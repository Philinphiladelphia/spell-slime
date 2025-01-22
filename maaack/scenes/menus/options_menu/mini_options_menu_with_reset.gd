extends MiniOptionsMenu

func _on_reset_game_control_reset_confirmed():
	DirAccess.remove_absolute("res://savedata/overworld_progress/progress.txt")
	GameLevelLog.reset_game_data()
