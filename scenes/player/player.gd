extends CharacterBody2D

signal health_depleted
signal level_up

var max_health := 100.0
var health := 100.0
var healing := 0.5
var damage := 25
var crit_rate := 0.15
var crit_damage := 1.75

var damage_cooldown := 1.0
var damage_timer := 0.0
var is_hurt := false

var xp_difficulty_bonus := 0
var pending_xp_bonus := 0  
const base_xp_per_level := 100
const XP_GROWTH := 25
var PENDING_LEVEL_UPS := 0

@export var movement_speed := 100

@onready var health_bar = get_node("TextureHealhBar")
@onready var xp_bar = $XpBar
@onready var level_label = $XpBar/Level
@onready var hurt_box = $HurtBox
@onready var animace = $Animace
@onready var hurt_sound = $HurtSound

const SLIMESCENE = preload("res://scenes/slimes/slime_green/slime.gd")

var character_direction := Vector2.ZERO

func _ready():
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
	
	update_xp_required()
	randomize()

func increase_max_health(amount: float):
	max_health += amount
	health = min(health + amount, max_health)

	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

var _xp := 0
var XP:
	get: return _xp
	set(value):
		_xp = value
		xp_bar.value = _xp
		check_XP()

var total_XP := 0
var _level := 1

var level:
	get: return _level
	set(value):
		_level = value
		level_label.text = "Lv " + str(_level)
		xp_difficulty_bonus += pending_xp_bonus
		pending_xp_bonus = 0
		update_xp_required()
		emit_signal("level_up")

func update_xp_required():
	xp_bar.max_value = base_xp_per_level + (_level - 1) * XP_GROWTH + xp_difficulty_bonus

func _physics_process(delta):

	character_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

	if character_direction.x > 0:
		animace.flip_h = false
	elif character_direction.x < 0:
		animace.flip_h = true

	move_and_slide()

	check_XP()
	damage_logic(delta)
	update_animation()

func damage_logic(delta):
	damage_timer -= delta
	if damage_timer > 0:
		return

	var bodies = hurt_box.get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group("slimes"):
			health -= body.damage
			damage_timer = damage_cooldown
			is_hurt = true

			hurt_sound.play()

			if health_bar:
				health_bar.value = health

			animace.play("hurt")

			await animace.animation_finished
			is_hurt = false

			if health <= 0:
				health_depleted.emit()
			break

func update_animation():

	if is_hurt:
		return

	if character_direction != Vector2.ZERO:
		if animace.animation != "runRed":
			animace.play("runRed")
	else:
		if animace.animation != "idleRed":
			animace.play("idleRed")


func gain_XP(amount):
	XP += amount
	total_XP += amount


func check_XP():
	while XP >= xp_bar.max_value:
		XP -= xp_bar.max_value
		PENDING_LEVEL_UPS += 1
		level += 1

func _on_healing_timer_timeout():

	if health < max_health:

		health += healing
		health = min(health, max_health)

		if health_bar:
			health_bar.value = health

func calculate_damage():

	var final_damage = damage
	var is_crit = false

	if randf() < crit_rate:
		final_damage *= crit_damage
		is_crit = true

	return [final_damage, is_crit]
