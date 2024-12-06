extends "res://addons/maaacks_game_template/base/scenes/opening/opening.gd"

var switch = true

func _process(delta: float) -> void:
	if next_image_index == 3 && switch && tween.finished:
		visible_time = 8
		%ImagesContainer.position = %ImagesContainer.position + Vector2(0,1) * -100
		switch = false
