class_name MagicMissle
extends Projectile

var missle_count = 5
var player: Node
var rotation_speed: float = 1.0
var is_rotating: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)

	if is_rotating:
		rotate_around_player(delta)

func rotate_around_player(delta: float) -> void:
	var player_position = PlayerState.player_location
	var direction = global_position.direction_to(player_position)
	var angle = direction.angle()
	global_position = player_position + Vector2(cos(angle), sin(angle)) * 100.0
	rotation += rotation_speed * delta

func activate_missile() -> void:
	is_rotating = false
	apply_force_to_nearest_enemy()

func apply_force_to_nearest_enemy() -> void:
	var enemy_locations = EnemyState.get_enemy_locations()
	var nearest_enemy: Vector2
	var nearest_distance: float = INF

	for enemy_pos in enemy_locations:
		var distance = global_position.distance_to(enemy_pos)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy_pos

	if nearest_enemy:
		var direction = global_position.direction_to(nearest_enemy)
		apply_impulse(direction * 2000)
