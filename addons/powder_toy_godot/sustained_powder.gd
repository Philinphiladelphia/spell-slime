class_name SustainPowder
extends Node

@export var duration: float = 0
@export var powderviewport: PowderViewport
var location: Vector2
var element: int
var radius: float
var remaining_time: float

var activated:bool = false

var ended: bool = false
signal end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func sustain_powder(location: Vector2, radius: float, element: int):
	self.location = location
	self.radius = radius
	self.element = element
	remaining_time = duration
	activated = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not activated:
		return
	
	if remaining_time > 0:
		powderviewport.circle(location, radius, element)
		remaining_time -= delta
	else:
		if not ended:
			end.emit()
			ended=true
