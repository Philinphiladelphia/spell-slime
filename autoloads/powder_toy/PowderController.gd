extends Node

var powder_toy: PowderViewport
signal powder_toy_set

func set_powder_toy(pt: PowderViewport):
	powder_toy = pt
	powder_toy_set.emit()

func summon_powder_toy(pos: Vector2):
	powder_toy.global_position = pos
