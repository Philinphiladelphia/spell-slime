extends Node2D

@export var gears_pins: Array[PinJoint2D]
@export var gun: Node2D
@export var active: bool = true

@export var show_turret: bool = true: set = set_turret
@export var show_boiler: bool = true
@export var show_gears: bool = true
@export var show_standpipe: bool = true

@export var turret: Node2D
@export var boiler: Node2D
@export var gears: Node2D
@export var standpipe: Node2D

func set_turret(value):
	if value:
		turret.show()
	else:
		turret.hide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func set_vehicle_state(active: bool):
	for gear in gears_pins:
		gear.motor_enabled = active
		
	gun.active = active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
