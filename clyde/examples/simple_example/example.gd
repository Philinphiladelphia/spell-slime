extends PanelContainer

# This is a simple example using the ClydeDialogue class.
# No helpers required.

@onready var _line_container = $MarginContainer/line
@onready var _options_container = $MarginContainer/options
@onready var _end_container = $MarginContainer/dialogue_ended

@export var speaker_themes: Dictionary = {
	"grandpa": preload("res://ui/themes/super_pixel_dark_grey.tres"),
	"slimey": preload("res://ui/themes/super_pixel_violet.tres"),
	"default_theme": preload("res://ui/themes/super_pixel_light_grey.tres")
}

signal on_dialogue_end

var _dialogue

var dialogue_path = 'pulp_with_blocks'

var _external_persistence = {}

var ended: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("primary_fire"):
		_get_next_dialogue_line()
	
	if not ended:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#if get_global_rect().has_point(get_global_mouse_position()):
		#MouseGlobal.set_mouse_owned(true)
		#
	#else:
		#MouseGlobal.set_mouse_owned(false)


func _ready():
	_dialogue = ClydeDialogue.new()
	_dialogue.load_dialogue(dialogue_path)

	_dialogue.event_triggered.connect(_on_event_triggered)
	_dialogue.variable_changed.connect(_on_variable_changed)

	_dialogue.on_external_variable_fetch(_on_external_variable_fetch)
	_dialogue.on_external_variable_update(_on_external_variable_update)
	
	# skip default text
	_get_next_dialogue_line()

func _get_next_dialogue_line():
	var content = _dialogue.get_content()
	if content.type == "end":
		_line_container.hide()
		_options_container.hide()
		_end_container.show()
		ended = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		MouseGlobal.set_mouse_owned(false)
		on_dialogue_end.emit()

	if content.type == 'line':
		_set_up_line(content)
		_line_container.show()
		_options_container.hide()
	else:
		_set_up_options(content)
		_options_container.show()
		_line_container.hide()

func set_speaker_theme(speaker: String):
	speaker = speaker.to_lower()
	if speaker_themes.has(speaker):
		theme = speaker_themes[speaker]
	else:
		theme = speaker_themes["default_theme"]

func _set_up_line(content):
	var speaker: String = content.get('speaker') if content.get('speaker') != null else ''
	_line_container.get_node("speaker").text = speaker
	_line_container.get_node("text").text = content.text
	
	set_speaker_theme(speaker)


func _set_up_options(options: Dictionary):
	for c in _options_container.get_node("items").get_children():
		c.queue_free()
		
	var speaker: String = options.get('speaker') if options.get('speaker') != null else ''

	_options_container.get_node("name").text = options.get('name') if options.get('name') != null else ''
	_options_container.get_node("speaker").text = speaker
	_options_container.get_node("speaker").visible = _options_container.get_node("speaker").text != ""
	
	set_speaker_theme(speaker)

	var index = 0
	if options["type"] == "end":
		return
	for option in options.options:
		var btn = Button.new()
		btn.text = option.label
		btn.custom_minimum_size = Vector2(600, 50)
		#btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.connect("button_down",Callable(self,"_on_option_selected").bind(index))
		_options_container.get_node("items").add_child(btn)
		index += 1


func _on_option_selected(index):
	_dialogue.choose(index)
	_get_next_dialogue_line()


func _gui_input(event):
	pass
	#if event is InputEventMouseButton and event.is_pressed():
		#_get_next_dialogue_line()


func _on_event_triggered(event_name, parameters):
	print("Event received: %s params: %s " % [event_name, parameters])


func _on_variable_changed(variable_name, new_value, previous_value):
	print("variable changed: %s old %s new %s" % [variable_name, previous_value, new_value])


func _on_restart_pressed():
	_end_container.hide()
	_dialogue.start()
	_get_next_dialogue_line()


# this is an example on how to provide access to external variables.
# The dialogue used in this example does not use external variables, but for instance,
# if it tried to access { @health }, this method would be called and return the value from
# _external_persistence["health"]
func _on_external_variable_fetch(variable_name: String):
	return _external_persistence[variable_name]


# This method is called when the dialogue tries to set an external variable. i.e { set @health = 10 }
func _on_external_variable_update(variable_name: String, value: Variant):
	_external_persistence[variable_name] = value
