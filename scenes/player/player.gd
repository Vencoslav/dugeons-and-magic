extends CharacterBody2D

signal health_depleted
signal level_up

var max_health := 100.0
var health := 100.0
var healing := 0.5
var damage := 25
var crit_rate := 0.15
var crit_damage := 1.75
@export var movement_speed := 100

var damage_cooldown := 1.0
var damage_timer := 0.0
var is_hurt := false

const BASE_XP_PER_LEVEL := 100
const XP_GROWTH := 30
var pending_level_ups := 0
var total_XP := 0

@onready var health_bar = get_node("TextureHealhBar")
@onready var xp_bar = $XpBar
@onready var level_label = $XpBar/Level
@onready var hurt_box = $HurtBox
@onready var animace = $Animace
@onready var hurt_sound = $HurtSound

var character_direction := Vector2.ZERO

var _xp := 0
var XP:
	get: return _xp
	set(value):
		_xp = value
		if xp_bar:
			xp_bar.value = _xp
		check_XP()

var _level := 1
var level:
	get: return _level
	set(value):
		_level = value
		if level_label:
			level_label.text = "Lv " + str(_level)
		update_xp_required()
		level_up.emit()

func _ready():
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
	update_xp_required()
	randomize()

func update_xp_required():
	if xp_bar:
		xp_bar.max_value = BASE_XP_PER_LEVEL + (_level - 1) * XP_GROWTH

func _physics_process(delta):
	character_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if character_direction != Vector2.ZERO:
		velocity = character_direction * movement_speed
		animace.flip_h = character_direction.x < 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

	move_and_slide()
	
	damage_logic(delta)
	update_animation()

func damage_logic(delta):
	if damage_timer > 0:
		damage_timer -= delta
		return

	var bodies = hurt_box.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("slimes"):
			take_damage(body.damage)
			break

func take_damage(amount):
	health -= amount
	damage_timer = damage_cooldown
	is_hurt = true
	
	if hurt_sound: hurt_sound.play()
	if health_bar: health_bar.value = health
	
	animace.play("hurt")
	await animace.animation_finished
	is_hurt = false

	if health <= 0:
		health_depleted.emit()

func update_animation():
	if is_hurt: return
	
	if character_direction != Vector2.ZERO:
		animace.play("runRed")
	else:
		animace.play("idleRed")

func gain_XP(amount):
	XP += amount
	total_XP += amount

func check_XP():
	while XP >= xp_bar.max_value:
		XP -= xp_bar.max_value
		pending_level_ups += 1
		level += 1

func increase_max_health(amount: float):
	max_health += amount
	health = min(health + amount, max_health)
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

func _on_healing_timer_timeout():
	if health < max_health:
		health = min(health + healing, max_health)
		if health_bar:
			health_bar.value = health

func calculate_damage():
	var final_damage = damage
	var is_crit = false
	if randf() < crit_rate:
		final_damage *= crit_damage
		is_crit = true
	return [final_damage, is_crit]
