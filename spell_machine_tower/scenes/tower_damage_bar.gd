extends TextureProgressBar

var current_health = 0.0
var spell_tower
var lerp_addition = 0.5

var health_bar_offset = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	spell_tower = parent.get_node("spell_machine_tower")
	max_value = parent.max_health
	current_health = parent.max_health
	value = parent.max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = spell_tower.position + health_bar_offset
	var new_value = lerp(value, current_health + (step*2), delta+lerp_addition)
	
	# give the asymptote an endpoint
	if abs(value-new_value) < (step*2):
		value = current_health
	else:
		value = new_value
