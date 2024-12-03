extends Node

var clear_timer : Timer

@onready var spawn_point = $ProjectileSpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# clear timer
	#clear_timer = Timer.new()
	#clear_timer.wait_time = 3
	#add_child(clear_timer)
	#clear_timer.connect("timeout", clear_projectiles)
	#clear_timer.start()
	#
func clear_projectiles():
	for child in spawn_point.get_children():
		child.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
