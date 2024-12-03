extends Node

var scenenode = preload("res://Scenes/slime_test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var instance = scenenode.instantiate()
	add_child(instance)
	
# I need to make a better player controller. I also need to rebuild my whole fucking scene
# note to self: use fucking git
