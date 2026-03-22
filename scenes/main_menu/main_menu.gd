extends Control


@onready var main_buttons = $MainButtons
@onready var settings = $Settings
@onready var settings_new = $Settings
@onready var key_binds = $KeyBinds

func _ready() -> void:
	main_buttons.visible = true
	settings.visible = false
	key_binds.visible = false

func _on_button_start_game_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func _on_button_settings_pressed() -> void:
	main_buttons.visible = false
	key_binds.visible = false
	settings.visible = true

func _on_button_exit_pressed() -> void:
	get_tree().quit()

func _on_button_back_pressed() -> void:
	main_buttons.visible = true
	settings.visible = false
	key_binds.visible = false
	
func _on_button_options_pressed() -> void:
	main_buttons = false
	key_binds.visible = false
	settings.visible = true
	
func _on_button_key_binds_pressed() -> void:
	key_binds.visible = true
	main_buttons.visible = false
	settings.visible = false

func _on_button_settins_pressed() -> void:
	main_buttons.visible = false
	key_binds.visible = false
	settings.visible = true
