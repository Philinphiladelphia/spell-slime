extends ProgressBar

var current_health = 0.0
var lerp_epsilon = 0.02

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_value = lerp(value,float(current_health), delta*2)
	
	# give the asymptote an endpoint
	if abs(value-new_value) < lerp_epsilon:
		value = current_health
	else:
		value = new_value
