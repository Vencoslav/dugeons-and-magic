extends CharacterBody2D

var health = 70
var speed = 15
var damage = 30

@onready var an = $animace_red
@onready var player = get_node("/root/game/player")
@onready var hurtSound = $HurtSound
@onready var critSound = $CritSound
@onready var deathSound = $DeadSound

const xp_scene = preload("res://xp.tscn")

func _ready():
	an.play("move")
	add_to_group("slimes")

func _physics_process(delta):
	var dist_to_player = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)
	var orbit_dir = Vector2(-direction.y, direction.x) 
	
	var steering = direction
	if dist_to_player < 100:
		steering = (direction + orbit_dir * 0.5).normalized()
	
	var target_velocity = steering * speed
	var bounce_impulse = Vector2.ZERO
	var neighbors = get_tree().get_nodes_in_group("slimes")
	
	for slime in neighbors:
		if slime != self:
			var dist = global_position.distance_to(slime.global_position)
			if dist < 17:
				var push_dir = (global_position - slime.global_position).normalized()
				bounce_impulse += push_dir * (17 - dist) * 25.0 
	
	velocity += bounce_impulse
	
	if dist_to_player < 25:
		velocity += -direction * (25 - dist_to_player) * 10.0

	velocity = velocity.lerp(target_velocity, delta * 3.0)
	
	move_and_slide()
	
	if velocity.x > 0: an.flip_h = false
	elif velocity.x < 0: an.flip_h = true
	
func take_damage():
	var result = player.calculate_damage()
	var final_damage = result[0]
	var is_crit = result[1]

	health -= final_damage
	
	var knockback_dir = player.global_position.direction_to(global_position)
	
	var base_strength = final_damage * 5.0
	var strength = base_strength + (100.0 if is_crit else 0.0)
	
	velocity += knockback_dir * clamp(strength, 50.0, 800.0)

	if health > 0:
		if is_crit and critSound and not critSound.playing:
			critSound.play()
		elif hurtSound and not hurtSound.playing:
			hurtSound.play()

		if is_crit:
			an.play("crit_hit")
			await an.animation_finished
		else:
			an.play("hurt")
			await an.animation_finished

		an.play("move")
		return

	if deathSound:
		var ds = deathSound.duplicate() # vytvoří kopii zvuku
		get_tree().current_scene.add_child(ds)
		ds.global_position = global_position
		ds.play()

	xp_drop(global_position)
	an.play("smoke")
	await an.animation_finished
	queue_free()

func xp_drop(pos: Vector2):
	call_deferred("_spawn_xp", pos)

func _spawn_xp(pos: Vector2):
	if not xp_scene:
		return

	var xp = xp_scene.instantiate()
	var game_root = get_tree().current_scene
	game_root.add_child(xp)

	xp.global_position = pos
	xp.z_index = 10

	if game_root.has_method("xp_pickup_speed_bonus"):
		xp.set_speed(xp.speed * game_root.xp_pickup_speed_bonus)
	else:
		xp.set_speed(xp.speed)
