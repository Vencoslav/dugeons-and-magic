extends Node2D

@onready var path_follow = $Path2D/PathFollow2D
@onready var timer = $Timer

var MobScene = preload("res://slime.tscn")

# globální floor oblast (musí sedět s mapou)
@export var floor_rect := Rect2(Vector2(0, 0), Vector2(1154, 656))

func _ready():
	randomize()
	timer.start()

func spawn_mob():
	var mob = MobScene.instantiate()
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position

	mob.floor_rect = floor_rect # předání inforamce a mapě slimům

	add_child(mob)

func _on_timer_timeout() -> void:
	spawn_mob()
