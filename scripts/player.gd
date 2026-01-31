extends CharacterBody2D

signal health_depleted
signal level_up

var max_health := 100.0
var health := 100.0
var damagePlayer := 25.0

@export var movementSpeed := 100.0

@onready var healthBar = get_node("TextureHealhBar")
const slime_scene = preload("res://slime.tscn")


@onready var xpBar = $XpBar
@onready var levelLabel = $XpBar/Level
@onready var hurtBox = $hurtBox
@onready var animace = $animace

var character_direction := Vector2.ZERO

func _ready():
	if healthBar:
		healthBar.max_value = max_health
		healthBar.value = 0  # naplnění vizuálně začne od 0

	# plynulé naplnění
	var tween = create_tween()
	tween.tween_property(healthBar, "value", health, 0.5)


func increase_max_health(amount: float):
	max_health += amount
	health += amount
	health = min(health, max_health)

	if healthBar:
		# Nastavení hodnot
		healthBar.max_value = max_health
		healthBar.value = health
		
var _xp := 0
var XP:
	get: return _xp
	set(value):
		_xp = value
		xpBar.value = _xp

var total_XP := 0

var _level := 1
var level:
	get: return _level
	set(value):
		_level = value
		levelLabel.text = "Lv " + str(_level)
		emit_signal("level_up")

		# Zvýšení max XP podle levelu
		if _level >= 7:
			xpBar.max_value = 40
		elif _level >= 3:
			xpBar.max_value = 20
	

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
	if hurtBox.get_overlapping_bodies().size() > 0:
		health -= slime_scene.damageSlime * delta   # damage od slima 
		healthBar.value = health

		if animace.animation != "hurt":
			animace.play("hurt")

		if health <= 0:
			health_depleted.emit()

func update_animation():
	if hurtBox.get_overlapping_bodies().size() > 0:
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
	if XP >= xpBar.max_value:
		XP -= xpBar.max_value
		level += 1
