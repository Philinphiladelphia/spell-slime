extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneLoader.load_scene("res://levels/moonswept_fields/day/moonrise_lighting.tscn")


func _on_button_2_pressed() -> void:
	SceneLoader.load_scene("res://levels/moonswept_fields/night/night_lighting.tscn")


func _on_button_3_pressed() -> void:
	SceneLoader.load_scene("res://example/overworld_example.tscn")
