extends Node2D

@export var shopkeeper: JumpingSlime

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shopkeeper.freeze()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_portal_portal_entered() -> void:
	SoundManager.stop_all()
	SceneLoader.load_scene("res://overworld/scenes/base_overworld.tscn")
