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
