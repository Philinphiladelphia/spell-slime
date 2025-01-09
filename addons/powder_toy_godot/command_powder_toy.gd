extends Node2D

var powder_toy: PackedScene = preload("res://addons/powder_toy_godot/powder_toy.tscn")

var powder_instance: Node
var health: int = 0

@export var sim_speed: float = 60.0

@export var cam: Camera2D

var ratio = 650.0/200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	powder_instance = powder_toy.instantiate()
	powder_instance.sim_speed = sim_speed
	$SubViewportContainer/SubViewport.add_child(powder_instance)

func get_health() -> int:
	return powder_instance.powder_toy.count_element(powder_instance.health_element)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_powder(pos, circle_size, element):
	var powder_pos: Vector2 = ((pos - cam.position)/ratio) + Vector2(115, 80)
	powder_instance.circle(Vector2(powder_pos.x,powder_pos.y), circle_size, element)
