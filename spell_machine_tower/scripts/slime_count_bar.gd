extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health_margin = 20

# goes off whenever health changes
var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	value = new_health
	
	timer.start()
	
	health = new_health

func init_health(_health):
	health = _health
	max_value = _health
	value = _health
	damage_bar.max_value = _health
	damage_bar.current_health = _health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	damage_bar.current_health = health
