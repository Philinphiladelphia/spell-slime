extends Node2D

var jump_interval = 4
var powder_interval = 3
var powder_duration = 2

var max_health = 1000.0
var jump_power = 8000

var element_numbers = [49, 129, 87]
# different shaders to show the more dangerous elements

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$slime_node.health_offset = Vector2(-300, -550)
	
	# must be done in this order
	$slime_node.set_max_health(max_health)
	$slime_node.set_health(max_health)
	$slime_node.jump_power = jump_power
	$slime_node.local_move_direction = Vector2(-0.3, -1).normalized()
	
	$slime_node.jump_interval = jump_interval
	$slime_node.powder_interval = powder_interval
	$slime_node.powder_duration = powder_duration
	$slime_node.element = element_numbers[randi() % element_numbers.size()]
	$slime_node.element_circle_size = 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("med slime controller freed")
		queue_free()
