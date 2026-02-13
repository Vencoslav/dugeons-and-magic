extends Node2D

const BULLET = preload("res://fireball.tscn")

signal auto_shoot_changed(enabled: bool)

var auto_shoot := false
const min_fire_time := 0.1

@onready var an = $Marker2D/animace
@onready var crysta: Marker2D = %shootingPoint
@onready var fire_timer: Timer = $FireTimer

func increase_fire_rate():
	fire_timer.wait_time *= 0.9
	fire_timer.wait_time = max(fire_timer.wait_time, min_fire_time)

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
	var main_level = get_tree().current_scene
	
	if "fireball_speed_bonus" in main_level:
		bullet_instance.speed = 300 * main_level.fireball_speed_bonus

	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = crysta.global_position
	bullet_instance.rotation = rotation
