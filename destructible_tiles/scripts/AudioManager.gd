extends Node

func _ready():
	randomize()

var audio_library = {
	"STONE_HIT":["res://destructible_tiles/resources/sfx/stone_hit.wav", "res://destructible_tiles/resources/sfx/stone_hit_2.wav"],
	"STONE_BREAK":["res://destructible_tiles/resources/sfx/stone_break.wav"],
	"LAND":["res://destructible_tiles/resources/sfx/land.wav", "res://destructible_tiles/resources/sfx/land_2.wav"],
}

func play_audio(audio_name):
	var sfx = load("res://destructible_tiles/assets/sfx/SFX.tscn").instantiate()
	get_node("/root").add_child(sfx)
	var audio = load(audio_library[audio_name][randi()%audio_library[audio_name].size()])
	sfx.stream = audio
	sfx.play()
