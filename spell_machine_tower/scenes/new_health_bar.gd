extends ProgressBar

@onready var damage_bar: Node = $DamageBar

var damage_timer : Timer

# goes off whenever health changes
var health: float = 0 : set = _set_health

func _set_health(new_health: float) -> void:
	health = new_health
	value = new_health
	damage_bar.current_health = new_health
	damage_timer.start()
	# healing

func init_health(_health: float) -> void:
	health = _health
	max_value = _health
	value = _health
	damage_bar.max_value = _health
	damage_bar.current_health = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# damage timer
	damage_timer = Timer.new()
	damage_timer.wait_time = 0.1
	damage_timer.one_shot=true
	add_child(damage_timer)
	damage_timer.connect("timeout", _on_timer_timeout)
	modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	damage_bar.current_health = health
