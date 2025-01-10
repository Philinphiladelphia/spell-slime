class_name HitMarker
extends Label

@export var distance: int = 20
@export var lifespan: float = 1

@onready var tween: Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)

@onready var spawn_time: float = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var end_loc: Vector2 = global_position - Vector2(0, distance)
	tween.tween_property(self, "global_position", end_loc, lifespan)
	tween.finished.connect(despawn)

func despawn():
	queue_free()

func set_damage(damage: int):
	text = str(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
