extends Node2D


## add the shader effect I want as a child and dig down like 3 levels.

# I should use native powder toy tools to make all the spells. totally possible.
# There are semipermeable walls already in the game.


# next, I would like to add UI elements. Tower health bar, progress in the current wave/progress in the level,
# Gatling cooldown, sword cooldown.

# [21, 87, 129]

# plasma, bomb, acid
var element_numbers = [49, 129, 21]

var jump_interval = 5
var powder_interval = 6
var powder_duration = 1

var max_health = 2000.0
var jump_power = 8000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$slime_node.health_offset = Vector2(-450, -900)
	
	# must be done in this order
	$slime_node.set_max_health(max_health)
	$slime_node.set_health(max_health)
	$slime_node.jump_power = jump_power
	$slime_node.local_move_direction = Vector2(-0.8, -1).normalized()
	
	$slime_node.jump_interval = jump_interval
	$slime_node.powder_interval = powder_interval
	$slime_node.powder_duration = powder_duration
	$slime_node.element = 129
	$slime_node.element_circle_size = 12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("large slime controller freed")
		queue_free()
