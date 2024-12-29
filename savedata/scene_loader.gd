extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func load_overworld():
	SceneLoader.load_scene("res://overworld/scenes/base_overworld.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	load_overworld()


func _on_button_2_pressed() -> void:
	load_overworld()


func _on_button_3_pressed() -> void:
	load_overworld()
