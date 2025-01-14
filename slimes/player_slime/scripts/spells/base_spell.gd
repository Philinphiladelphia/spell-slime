class_name Spell
extends Resource

@export var fire_rate: float = 0.5
@export var min_cast_cost: float = 5
@export var damage: int = 2
@export var per_second_mana_consumption: int = 10
@export var mass: float = 10
@export var velocity: int = 1000
@export var max_lifespan: float = 2.0
@export var post_hit_lifespan: float = 0.2
@export var shake: float = 0.03

# scaling per cast_power
@export var damage_scaling: float = 0.2

@export var size_scaling: float = 0.1

@export var mass_scaling: float = 0.2
@export var velocity_scaling: float = 30.0

@export var projectile_type: String = "res://upgrade_tree/scenes/harpoon_projectile.tscn"
@export var sound: String = "harpoon"
