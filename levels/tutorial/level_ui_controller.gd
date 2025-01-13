class_name LevelUIController
extends CanvasLayer

@export var hp_bar: HealthBar
@export var ammo_bar: HealthBar
@export var mana_bar: HealthBar
@export var enemy_hp_bar: HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammo_bar.set_bar(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
