extends Node2D

@onready var powder_toy: Node = %PowderToyGodot

# while the spellward is active, slime hits deal greatly reduced damage to the tower.

func _ready() -> void:
    powder_toy.sim_speed = sim_speed
    powder_toy.set_edge_mode(0)
    powder_toy.set_grav_mode(0)
    
    circle(Vector2(60,50), 5, 87)

func circle(pos: Vector2, radius: float, element: int) -> void:
    powder_toy.powder_circle(pos.x, pos.y, radius, element)