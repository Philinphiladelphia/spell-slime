extends Node2D

var start_powder: Timer
var stop_powder: Timer
var powdering = false

var slime_element = 4 # fire
var central_slime_element = 49 # plasma

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PowderViewport.powder_instance.powder_toy.powder_box(10, 65, 110, 40, 114)
	
	start_powder = Timer.new()
	start_powder.wait_time = 3
	add_child(start_powder)
	start_powder.one_shot = true
	start_powder.connect("timeout", start_slime_powder)
	start_powder.start()
	
	stop_powder = Timer.new()
	stop_powder.wait_time = 6
	add_child(stop_powder)
	stop_powder.one_shot = true
	stop_powder.connect("timeout", stop_slime_powder)
	
func stop_slime_powder():
	powdering = false
	
func start_slime_powder():
	powdering = true
	stop_powder.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if powdering:
		var i = 0
		var element = slime_element
		var radius = 1
		for slime in $slimes.get_children():
			if i == 1:
				element = central_slime_element
				radius = 3
			else:
				element = slime_element
				radius = 1
				
			var powder_pos = slime.get_node("Marker2D").global_position
			$PowderViewport.powder_instance.powder_toy.powder_circle((powder_pos.x/12) + 5, (powder_pos.y/12) + 37, radius, element)
			i = i + 1
			
	
	set_modulate(lerp(get_modulate(), Color(1,1,1,1), delta/2))
