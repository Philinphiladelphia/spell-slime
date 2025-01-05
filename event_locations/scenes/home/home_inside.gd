extends "res://event_locations/event_base.gd"

@export var spell_vehicle: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	spell_vehicle.set_vehicle_state(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
