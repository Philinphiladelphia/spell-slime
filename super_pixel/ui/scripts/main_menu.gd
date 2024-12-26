extends Control

func _on_sunset_level_pressed() -> void:
	YASM.load_scene("res://levels/scenes/sunset_level.tscn")


func _on_night_level_pressed() -> void:
	YASM.load_scene("res://levels/scenes/night_lighting.tscn")
