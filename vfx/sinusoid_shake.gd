extends Node2D

# Exported variables for configuring the shake
@export var amplitude_x: float = 10.0
@export var frequency_x: float = 1.0
@export var phase_shift_x: float = 0.0

@export var amplitude_y: float = 10.0
@export var frequency_y: float = 1.0
@export var phase_shift_y: float = 0.0

# Time variable to keep track of the elapsed time
var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var new_x = amplitude_x * sin(frequency_x * time + phase_shift_x)
	var new_y = amplitude_y * sin(frequency_y * time + phase_shift_y)
	position = Vector2(new_x, new_y)
