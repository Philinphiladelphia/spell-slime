extends CanvasModulate

var night_level = preload("res://levels/moonswept_fields/day/moonrise_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var night_instance = night_level.instantiate()
	add_child(night_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
