extends Node2D

@onready var player = get_node("/root/game/tilemap/player")
const BULLET = preload("res://fireball.tscn")
@onready var an = $Marker2D/animace


@onready var crysta: Marker2D = %shootingPoint


func _process(delta):
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("fire"):
		shoot()
		

func shoot():
	an.play("cast")
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = crysta.global_position
	bullet_instance.rotation = rotation
		


	
	
