extends LevelWonMenu

@onready var rewards_screen = preload("res://ui/scenes/rewards_screen.tscn")
@export_file("*.tscn") var main_menu_scene : String

func _on_continue_pressed() -> void:
	var rewards: Node = rewards_screen.instantiate()
	#rewards.global_position = camera_node.global_position
	get_parent().add_child(rewards)
	queue_free()

func _on_main_menu_pressed() -> void:
	SceneLoader.load_scene(main_menu_scene)
	close()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# minibosses are just hard, unique levels. 
# events, shops, three kinds of battle, free treasure
# put em all together and make a game
