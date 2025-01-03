extends Node2D

@export var camera_node: Camera2D

var home_dialogue = preload("res://clyde/examples/simple_example/example.tscn")

@onready var pause_screen: PackedScene = preload("res://maaack/scenes/overlaid_menus/pause_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialogue = home_dialogue.instantiate()
	camera_node.add_child(dialogue)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("pause"):
		var pause: Node = pause_screen.instantiate()
		$slime_health_layer.add_child(pause)
