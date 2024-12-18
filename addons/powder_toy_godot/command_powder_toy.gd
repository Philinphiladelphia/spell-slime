extends Node2D

var powder_toy = preload("res://addons/powder_toy_godot/powder_toy.tscn")

var powder_instance
var health = 0

@export var sim_speed = 60.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powder_instance = powder_toy.instantiate()
	powder_instance.sim_speed = sim_speed
	$SubViewportContainer/SubViewport.add_child(powder_instance)

func get_health():
	return powder_instance.powder_toy.count_element(powder_instance.health_element)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
