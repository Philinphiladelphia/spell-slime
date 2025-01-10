class_name HitMarker
extends Label

@export var speed: float = 0.05
@export var lifespan: float = 10

@onready var spawn_time: float = Time.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_damage(damage: int):
	text = str(damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Time.get_ticks_msec() - spawn_time) >= (lifespan*1000):
		queue_free()
		
	position.y = position.y - speed
