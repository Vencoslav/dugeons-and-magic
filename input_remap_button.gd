extends Button
class_name InputReMapButton

@export var action: String
@export var manager: Node  # odkaz na KeybindsManager

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

func _unhandled_input(event: InputEvent) -> void:
	if !is_pressed():
		return
	
	if event.is_pressed() and (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton):
		var events = InputMap.action_get_events(action)
		for e in events:
			InputMap.action_erase_event(action, e)
		
		InputMap.action_add_event(action, event)
		release_focus()
		button_pressed = false
		update_text()  # ← tady už nebude padat
		if manager:
			manager._save_keybinds()
