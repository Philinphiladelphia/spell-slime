extends LevelLostMenu

@export_file("*.tscn") var main_menu_scene : String

func _on_main_menu_pressed() -> void:
	SceneLoader.load_scene(main_menu_scene)
	close()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
