extends Node2D

var decorations: Array[Sprite2D]

@export var slime_node: Node2D

@export var descriptor: SlimeDescriptor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_sfx(descriptor.spawn_sound, 0, -12, 3)
	
	$slime_node.health_offset = $slime_node/health_bar.position
	
	# must be done in this order
	$slime_node.set_max_health(descriptor.max_health)
	$slime_node.set_health(descriptor.max_health)
	$slime_node.jump_power = descriptor.jump_power
	$slime_node.local_move_direction = descriptor.local_move_dir.normalized()
	
	$slime_node.upright_torque = descriptor.upright_torque
	$slime_node.jump_interval = descriptor.jump_interval
	$slime_node.powder_interval = descriptor.powder_interval
	$slime_node.powder_duration = descriptor.powder_duration
	$slime_node.element = descriptor.element_numbers[randi() % descriptor.element_numbers.size()]
	$slime_node.set_original_color(EnemyState.slime_colors[$slime_node.element])
	$slime_node.element_circle_size = descriptor.element_circle_size
	$slime_node.damage = descriptor.damage
	
func set_element(element: int) -> void:
	$slime_node.element = element

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $slime_node.garbage_collect:
		print("small slime controller freed")
		queue_free()

func apply_damage(amount: float) -> void:
	$slime_node.apply_damage(amount)
