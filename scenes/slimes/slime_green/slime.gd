extends CharacterBody2D

var health = 50
var speed = 25
var damage = 20
var base_xp = 50

@onready var an = $AnimaceGreen
@onready var player = get_node("/root/Game/Player")
@onready var hurt_sound = $HurtSound
@onready var crit_sound = $CritSound
@onready var death_sound = $DeadSound
@onready var slime_level = $SlimeLevel

const XP_SCENE = preload("res://scenes/xp/xp.tscn")

func _ready():
	an.play("move")
	add_to_group("slimes")
	update_level_display()

func _physics_process(delta):
	var dir = global_position.direction_to(player.global_position)
	var dist = global_position.distance_to(player.global_position)

	var orbit = Vector2(-dir.y, dir.x) * clamp((dist - 30.0) / 70.0, 0.0, 1.0)
	var target_velocity = (dir + orbit * 0.5).normalized() * speed

# vyhýbání se ostatním slime
	var push = Vector2.ZERO
	for s in get_tree().get_nodes_in_group("slimes"):
		if s != self and is_instance_valid(s):
			var d = global_position.distance_to(s.global_position)
			if d < 16:
				push += (global_position - s.global_position).normalized() * (16 - d) * 15.0

	velocity += push
	velocity = velocity.lerp(target_velocity, delta * 4.0)

	move_and_slide()
		
func update_level_display():
	# základní HP je 50 = Level 1 když se zvýší +1 Level
	var current_level = 1 + int((health - 50) / 5)
	if slime_level:
		var display_lvl = max(1, current_level)
		slime_level.text = "Lvl: " + str(display_lvl)
	
func take_damage():
	var result = player.calculate_damage()
	var final_damage = result[0]
	var is_crit = result[1]

	health -= final_damage
	
	var knockback_dir = player.global_position.direction_to(global_position)
	var base_strength = final_damage * 5.0
	var strength = base_strength + (100.0 if is_crit else 0.0)
	
	velocity += knockback_dir * clamp(strength, 50.0, 800.0)

	if is_crit and crit_sound:
		crit_sound.play()
	elif hurt_sound:
		hurt_sound.play()

	if is_crit:
		an.play("crit_hit")
		await an.animation_finished
	elif health > 0: 
		an.play("hurt")
		await an.animation_finished

	if health <= 0:
		if death_sound:
			var ds = death_sound.duplicate() # vytvoření kopie zvuku
			get_tree().current_scene.add_child(ds)
			ds.global_position = global_position
			ds.play()

		xp_drop(global_position)
		an.play("smoke")
		await an.animation_finished
		queue_free()
	else:
		an.play("move")

func xp_drop(pos: Vector2):
	var current_level = 1 + int((health - 50) / 5)
	var final_xp = base_xp + (max(0, current_level - 1) * 2)
	
	call_deferred("_spawn_xp", pos, final_xp)
	
	call_deferred("_spawn_xp", pos, final_xp)
func _spawn_xp(pos: Vector2, xp_val: int):
	if not XP_SCENE: return

	var xp = XP_SCENE.instantiate()
	get_tree().current_scene.add_child(xp)
	
	xp.global_position = pos
	xp.z_index = 1
	
	# přídání hodnoty xp
	if xp.has_method("set_xp_amount"):
		xp.set_xp_amount(xp_val)
