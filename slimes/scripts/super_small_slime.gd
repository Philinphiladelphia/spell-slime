extends Node2D

var jump_interval: float = 2.5
var powder_interval: float = 2
var powder_duration: float = 0.5

var max_health: float = 200.0
var jump_power: float = 100
var element_numbers: PackedInt32Array = [21, 3, 4, 6, 7]

var decorations: Array[Sprite2D]

@export var slime_node: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_sfx("slime1", 0, -12, 3)
	
	$slime_node.health_offset = $slime_node/health_bar.position
	
	# must be done in this order
	$slime_node.set_max_health(max_health)
	$slime_node.set_health(max_health)
	$slime_node.jump_power = jump_power
	$slime_node.local_move_direction = Vector2(-0.5, -1).normalized()
	
	$slime_node.upright_torque = 2000
	$slime_node.jump_interval = jump_interval
	$slime_node.powder_interval = powder_interval
	$slime_node.powder_duration = powder_duration
	$slime_node.element = element_numbers[randi() % element_numbers.size()]
	$slime_node.set_original_color(get_parent().slime_colors[$slime_node.element])
	$slime_node.element_circle_size = 2
	$slime_node.damage = 2
	
func set_element(element: int) -> void:
	$slime_node.element = element
	$slime_node.set_original_color(get_parent().slime_colors[$slime_node.element])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("small slime controller freed")
		queue_free()

func apply_damage(amount: float) -> void:
	$slime_node.apply_damage(amount)
