extends Node

var blue_crystal: PackedScene = preload("res://slimes/scenes/crystals/crystal.tscn")

func spawn_crystal(pos: Vector2, crystal_type: String):
	match crystal_type:
		"blue":
			var crystal: Crystal = blue_crystal.instantiate()
			crystal.global_position = pos
			get_tree().root.add_child(crystal)
