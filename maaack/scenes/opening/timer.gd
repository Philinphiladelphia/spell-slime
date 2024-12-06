extends Timer

var rocking_slime = preload("res://maaack/scenes/opening/rocking_slime.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	var slime_copy = rocking_slime.instantiate()
	add_child(slime_copy)
	
