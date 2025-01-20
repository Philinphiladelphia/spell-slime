extends TileMapLayer

@export var area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if area.has_overlapping_bodies():
		modulate = lerp(modulate, Color(modulate, 0), delta*2)
	else:
		modulate = lerp(modulate, Color(modulate, 1), delta*2)
