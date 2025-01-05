extends CanvasLayer

var has_active_dialogue: bool = false

@export var dialogues: Array[String]
var dialogue_index = 0

signal dialogue_ended

var base_dialogue = preload("res://clyde/base_dialogue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func play_next_dialogue():
	var current_dialogue = base_dialogue.instantiate()
	current_dialogue.set_dialogue_path(dialogues[dialogue_index])
	
	current_dialogue.get_child(0).on_dialogue_end.connect(clear_dialogue)
	add_child(current_dialogue)
	
	dialogue_index += 1

func clear_dialogue():
	for child in get_children():
		child.queue_free()

	dialogue_ended.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(get_children()) > 0:
		has_active_dialogue = true
	else:
		has_active_dialogue = false
