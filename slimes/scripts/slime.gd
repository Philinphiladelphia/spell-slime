extends Node

var slime = preload("res://v1_slimes/slimes/slime.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var instance = slime.instantiate()
	add_child(instance)
