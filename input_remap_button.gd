extends Button
class_name InputReMapButton

@export var action: String
@export var manager: Node

func _ready():
	toggle_mode = true
	update_text()

func update_text() -> void:
	if !action or !InputMap.has_action(action):
		text = "Unassigned"
		return
	
	var events = InputMap.action_get_events(action)
	if events.size() == 0:
		text = "Unassigned"
		return
	
	var input = events[0]
	if input is InputEventKey:
		if input.physical_keycode != 0:
			text = OS.get_keycode_string(input.physical_keycode)
		else:
			text = OS.get_keycode_string(input.keycode)
	elif input is InputEventMouseButton:
		text = "Mouse " + str(input.button_index)
	elif input is InputEventJoypadButton:
		text = "Joy " + str(input.button_index)

func _gui_input(event: InputEvent) -> void:
	if button_pressed and event is InputEventMouseButton and event.is_pressed():
		_rebind(event)

func _unhandled_input(event: InputEvent) -> void:
	if !button_pressed:
		return
	
	if event.is_pressed() and (event is InputEventKey or event is InputEventJoypadButton):
		_rebind(event)

func _rebind(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	
	var events = InputMap.action_get_events(action)
	for e in events:
		InputMap.action_erase_event(action, e)
	
	InputMap.action_add_event(action, event)
	
	# Reset stavu
	button_pressed = false
	release_focus()
	update_text()
	
	if manager:
		manager._save_keybinds()
