class_name OutOfAmmo
extends Node2D

@export var blink_speed = 0.5
@export var active: bool = false
var blink_timer: float = blink_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active:
		return
	
	blink_timer -= delta
	
	if blink_timer <= 0:
		if is_visible_in_tree():
			hide()
		else:
			show()
		
		blink_timer = blink_speed
