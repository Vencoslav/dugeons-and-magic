extends Control


@onready var mainButtons = $MainButtons
@onready var options = $Options
@onready var keyBinds = $KeyBinds

func _ready() -> void:
	mainButtons.visible = true
	options.visible = false
	keyBinds.visible = false

func _on_button_start_game_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game.tscn")


func _on_button_settings_pressed() -> void:
	mainButtons.visible = false
	options.visible = true


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_back_pressed() -> void:
	_ready()
	


func _on_button_options_pressed() -> void:
	mainButtons.visible = false
	options.visible = true
	keyBinds.visible = false
	
func _on_button_key_binds_pressed() -> void:
	keyBinds.visible = true
	mainButtons.visible = false
	options.visible = false


func _on_game_music_control_pressed() -> void:
	pass # Replace with function body.
