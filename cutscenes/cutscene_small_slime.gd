extends Node2D

var jump_interval = 4
var powder_interval = 2
var powder_duration = 0.2

var jump_power = 20

var element_numbers = [21, 3, 4, 6, 7]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$slime_node.jump_power = jump_power
	$slime_node.local_move_direction = Vector2(-0.5, -1).normalized()
	
	$slime_node.jump_interval = jump_interval
	$slime_node.powder_interval = powder_interval
	$slime_node.powder_duration = powder_duration
	$slime_node.element = element_numbers[randi() % element_numbers.size()]
	$slime_node.element_circle_size = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("small slime controller freed")
		queue_free()
