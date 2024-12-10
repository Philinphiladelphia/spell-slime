extends Node2D

var jump_interval = 4
var powder_interval = 2
var powder_duration = 0.2

var max_health = 200.0
var jump_power = 1000

var element_numbers = [21, 3, 4, 6, 7]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_sfx("slime1", 0, -6, 3)
	
	$slime_node.health_offset = Vector2(-150, -250)
	
	# must be done in this order
	$slime_node.set_max_health(max_health)
	$slime_node.set_health(max_health)
	$slime_node.jump_power = jump_power
	$slime_node.local_move_direction = Vector2(-0.5, -1).normalized()
	
	$slime_node.jump_interval = jump_interval
	$slime_node.powder_interval = powder_interval
	$slime_node.powder_duration = powder_duration
	$slime_node.element = element_numbers[randi() % element_numbers.size()]
	$slime_node.element_circle_size = 1
	$slime_node.damage = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("small slime controller freed")
		queue_free()

func apply_damage(amount):
	$slime_node.apply_damage(amount)
