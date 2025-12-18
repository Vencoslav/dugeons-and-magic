extends Node2D

@onready var path_follow = $Path2D/PathFollow2D
var MobScene = preload("res://slime.tscn")

func _ready():
	randomize()
	for i in range(5):
		spaw_mob()

func spaw_mob():
	var mob = MobScene.instantiate()
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position
	mob.z_index = 10
	add_child(mob)
