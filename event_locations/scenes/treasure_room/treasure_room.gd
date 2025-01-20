extends Node2D

@export var items: Array[ItemPedestal]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_portal_portal_entered() -> void:
	SoundManager.stop_all()
	SceneLoader.load_scene("res://overworld/scenes/base_overworld.tscn")


func _on_item_pedestal_item_taken() -> void:
	for item in items:
		item.destroy_item()
