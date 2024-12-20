extends LevelWonMenu

@onready var rewards_screen = preload("res://ui/scenes/rewards_screen.tscn")

func _on_continue_pressed() -> void:
	var rewards: Node = rewards_screen.instantiate()
	#rewards.global_position = camera_node.global_position
	get_parent().add_child(rewards)
	queue_free()
