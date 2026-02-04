extends Node2D

const BULLET = preload("res://fireball.tscn")

signal auto_shoot_changed(enabled: bool)

var auto_shoot := false

@onready var an = $Marker2D/animace
@onready var crysta: Marker2D = %shootingPoint
@onready var fire_timer: Timer = $FireTimer


func _process(_delta):
	look_at(get_global_mouse_position())

	rotation_degrees = wrap(rotation_degrees, 0, 360)
	scale.y = -1 if rotation_degrees > 90 and rotation_degrees < 270 else 1

	if Input.is_action_just_pressed("auto_shoot"):
		auto_shoot = !auto_shoot
		auto_shoot_changed.emit(auto_shoot)

	if Input.is_action_pressed("fire") or auto_shoot:
		try_shoot()


func try_shoot():
	if not fire_timer.is_stopped():
		return

	shoot()
	fire_timer.start()


func shoot():
	an.play("cast")
	var bullet_instance = BULLET.instantiate()
	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = crysta.global_position
	bullet_instance.rotation = rotation
