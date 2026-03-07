extends Button

@export var action: String
@onready var inputMapper = $".."

func _ready():
	toggle_mode = true
	set_process_unhandled_input(false)
	update_text()

func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "Awaiting Input"

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		release_focus()
		update_text()
		inputMapper.keyMaps[action] = event
		inputMapper.save_keymap()

func update_text():
	var events = InputMap.action_get_events(action)
	if events.size() > 0:
		text = OS.get_keycode_string(events[0].keycode)
	else:
