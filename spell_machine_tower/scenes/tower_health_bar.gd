extends TextureProgressBar

var spell_tower
var current_health = 0.0

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
	value = current_health
	position = spell_tower.position + health_bar_offset
