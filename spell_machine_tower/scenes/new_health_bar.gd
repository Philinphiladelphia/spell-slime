class_name HealthBar
extends ProgressBar

var bar_value: float = 0 : set = set_bar

func set_bar(new_value: float) -> void:
	bar_value = new_value
	value = new_value

func init_bar(new_value: float) -> void:
	bar_value = new_value
	max_value = new_value
	value = new_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
