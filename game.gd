extends Node2D

@onready var path_follow = $Path2D/PathFollow2D
var MobScene = preload("res://slime.tscn")

# globální floor oblast (Rect2)
@export var floor_rect := Rect2(Vector2(0, 0), Vector2(1154.0, 656.0))

func _ready():
	randomize()
	for i in range(5):
		spaw_mob()

func spaw_mob():
	var mob = MobScene.instantiate()
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position
	
	# přidej floor_rect do mobu
	mob.floor_rect = floor_rect
	
	add_child(mob)
