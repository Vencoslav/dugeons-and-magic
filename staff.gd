extends Node2D

@onready var player = get_node("/root/game/tilemap/player")
const BULLET = preload("res://fireball.tscn")

@onready var crysta: Marker2D = %shootingPoint

func _process(delta):
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("fire"):
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = crysta.global_position
		bullet_instance.rotation = rotation
		


	
	
#func shoot():
#	const BULLET = preload("res://fireball.tscn")
#	var new_bullet = BULLET.instantiate()
#	new_bullet.global_position = %shootingPoint.global_position
#	%shootingPoint.add_child(new_bullet)
	
	



#func _on_timer_timeout():
#	shoot()
