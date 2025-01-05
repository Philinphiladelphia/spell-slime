extends Node2D

@export var gears: Array[PinJoint2D]
@export var gun: Node2D
@export var active: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_vehicle_state(active: bool):
	for gear in gears:
		gear.motor_enabled = active
		
	gun.active = active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
