extends Node2D

var bgMusic = 'res://music/assets/lehrer/10-New-Math.mp3'

func _ready():
	if not $BGM.playing:
		$BGM.stream = load(bgMusic)
		$BGM.play()
