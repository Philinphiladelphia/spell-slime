class_name FiringStrategy
extends Resource

@export var firing_interval: float
@export var ammo: int = 0
@export var velocity: float = 0
@export var shake: float = 0

var last_shot_ms: int = 0

func register_shot_fired(turret: Turret):
	last_shot_ms = Time.get_ticks_msec()
	ammo -= 1

func off_cooldown(turret: Turret):
	return (Time.get_ticks_msec() - last_shot_ms) > (firing_interval*1000)
