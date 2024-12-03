extends TextureProgressBar

var current_health = 0.0
var slime_soft_body
var lerp_epsilon = 0.08

var bone_number = 0

var health_bar_offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	slime_soft_body = parent.get_node("slime_soft_body/Bone-" + str(bone_number))
	
func set_max_health(amount):
	max_value = amount
	current_health = amount
	value = amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = slime_soft_body.position + health_bar_offset
	var new_value = lerp(value,float(current_health), delta)
	
	# give the asymptote an endpoint
	if abs(value-new_value) < lerp_epsilon:
		value = current_health
	else:
		value = new_value
