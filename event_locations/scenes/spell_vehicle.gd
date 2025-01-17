class_name SpellVehicle
extends Node2D

@export var gears_pins: Array[PinJoint2D]
@export var gun: Node2D
@export var active: bool = true

@export var turret: Node2D
@export var boiler: Node2D
@export var gears: Node2D
@export var standpipe: Node2D

@export var hide: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hide:
		turret.hide()
		boiler.hide()
		gears.hide()
		standpipe.hide()
	
func set_vehicle_state(active: bool):
	for gear in gears_pins:
		gear.motor_enabled = active
		
	gun.active = active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
