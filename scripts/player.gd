extends CharacterBody2D

signal health_depleted
signal level_up

var max_health := 100.0
var health := 100.0
var healing := 0.25
var damage := 25
var crit_rate := 0.1
var crit_damage := 1.5

var damage_cooldown := 1.0
var damage_timer := 0.0
var is_hurt := false

var xp_difficulty_bonus := 0
var pending_xp_bonus := 0  
const base_xp_per_level := 100
const xp_growth := 25
var pending_level_ups := 0

@export var movementSpeed := 100

@onready var healthBar = get_node("TextureHealhBar")
@onready var xpBar = $XpBar
@onready var levelLabel = $XpBar/Level
@onready var hurtBox = $hurtBox
@onready var animace = $animace
@onready var hurtSound = $HurtSound

const slime_scene = preload("res://slime.tscn")

var character_direction := Vector2.ZERO

func _ready():
	if healthBar:
		healthBar.max_value = max_health
		healthBar.value = health
	
	update_xp_required()
	randomize()

func increase_max_health(amount: float):
	max_health += amount
	health = min(health + amount, max_health)

	if healthBar:
		healthBar.max_value = max_health
		healthBar.value = health

var _xp := 0
var XP:
	get: return _xp
	set(value):
		_xp = value
		xpBar.value = _xp
		check_XP()

var total_XP := 0
var _level := 1

var level:
	get: return _level
	set(value):
		_level = value
		levelLabel.text = "Lv " + str(_level)
		xp_difficulty_bonus += pending_xp_bonus
		pending_xp_bonus = 0
		update_xp_required()
		emit_signal("level_up")

func update_xp_required():
	xpBar.max_value = base_xp_per_level + (_level - 1) * xp_growth + xp_difficulty_bonus

func _physics_process(delta):

	character_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * movementSpeed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movementSpeed)

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

	var bodies = hurtBox.get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group("slimes"):
			health -= body.damage
			damage_timer = damage_cooldown
			is_hurt = true

			hurtSound.play()

			if healthBar:
				healthBar.value = health

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
	while XP >= xpBar.max_value:
		XP -= xpBar.max_value
		pending_level_ups += 1
		level += 1

func _on_healing_timer_timeout():

	if health < max_health:

		health += healing
		health = min(health, max_health)

		if healthBar:
			healthBar.value = health

func calculate_damage():

	var final_damage = damage
	var is_crit = false

	if randf() < crit_rate:
		final_damage *= crit_damage
		is_crit = true

	return [final_damage, is_crit]
