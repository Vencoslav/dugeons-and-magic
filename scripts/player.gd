extends CharacterBody2D

signal health_depleted

var health = 100.0
var damageRate := 25.

var character_direction : Vector2
@export var movementSpeed : float = 100.0
@onready var healthBar = $HealthBar
@onready var xpBar = $XpBar
@onready var levelLabel = $XpBar/Level
@onready var hurtBox = %hurtBox
@onready var animace = %animace

var _xp := 0
var XP:
	get:
		return _xp
	set(value):
		_xp = value
		xpBar.value = _xp

var total_XP := 0

var _level := 1
var level:
	get:
		return _level
	set(value):
		_level = value
		levelLabel.text = "Lv " + str(_level)

		if _level >= 7:
			xpBar.max_value = 40
		elif _level >= 3:
			xpBar.max_value = 20

func _physics_process(delta):
	character_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	# pohyb (bez dvojnásobné rychlosti do rohu)
	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * movementSpeed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movementSpeed)

	# otočení sprite
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
		health -= damageRate * delta
		healthBar.value = health

		if animace.animation != "hurt":
			animace.play("hurt")

		if health <= 0.0:
			health_depleted.emit()

func update_animation():
	# animace jen pokud hráč NEDOSTÁVÁ damage
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
