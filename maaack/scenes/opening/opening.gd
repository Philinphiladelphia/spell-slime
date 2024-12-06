extends "res://addons/maaacks_game_template/base/scenes/opening/opening.gd"

var rocking_slime = preload("res://maaack/scenes/opening/rocking_slime.tscn")

var switch = true
var final_scene: Timer

func _ready() -> void:
	super()
	final_scene = Timer.new()
	final_scene.wait_time = 3
	add_child(final_scene)
	final_scene.one_shot = true
	final_scene.connect("timeout", run_powder_slimes)

func _process(delta: float) -> void:
	if next_image_index == 2 && switch:
		final_scene.start()
		switch = false

func run_powder_slimes():
	var slime_copy = rocking_slime.instantiate()
	add_child(slime_copy)
