extends Control


@onready var mainButtons = $MainButtons
@onready var settings = $Settings
@onready var keyBinds = $KeyBinds

func _ready() -> void:
	mainButtons.visible = true
	settings.visible = false
	keyBinds.visible = false

func _on_button_start_game_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func _on_button_settings_pressed() -> void:
	mainButtons.visible = false
	settings.visible = true


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_back_pressed() -> void:
	mainButtons.visible = true
	settings.visible = false
	keyBinds.visible = false
	
func _on_button_options_pressed() -> void:
	mainButtons.visible = false
	keyBinds.visible = false
	settings.visible = true
	
	
func _on_button_key_binds_pressed() -> void:
	keyBinds.visible = true
	mainButtons.visible = false
	settings.visible = false
