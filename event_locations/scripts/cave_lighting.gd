extends TileMapLayer

@export var area: Area2D
@export var lighting: CanvasModulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if area.has_overlapping_bodies():
		lighting.color = lerp(lighting.color, Color(0.4,0.4, 0.4), delta*2)
		modulate = lerp(modulate, Color(modulate, 0), delta*2)
	else:
		lighting.color = lerp(lighting.color, Color(1,1, 1), delta*2)
		modulate = lerp(modulate, Color(modulate, 1), delta*2)
