extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var i: int = 0
	for child in get_children():
		for double_child in child.get_children():
			double_child.hide()
			i += 1
	
	var selected_gem: int = randi_range(0, i)
	
	var j: int = 0
	for child in get_children():
		for double_child in child.get_children():
			if selected_gem == j:
				child.show()
				child.position = Vector2(0,0)
				double_child.show()
				double_child.position = Vector2(0,0)
			j+= 1
			
