extends Node2D

@onready var path_follow = %PathFollow2D
@onready var timer = $Timer

func spawn_mob():
	var mob = preload("res://slime.tscn").instantiate()
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position

	add_child(mob)

func _on_timer_timeout() -> void:
	spawn_mob()


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true
	

	


func _on_button_exit_pressed() -> void:
	get_tree().quit()

func _on_button_try_again_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
