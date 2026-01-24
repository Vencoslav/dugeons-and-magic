extends CharacterBody2D

signal health_depleted

var health = 100.0
var damageRate := 25.0

var character_direction : Vector2
@export var movementSpeed : float = 100.0
@onready var healthBar = $HealthBar
@onready var xpBar = $XpBar
@onready var levelLabel = $XpBar/Level

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
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized() * movementSpeed # opravuje 2x rychlost když jdeš směrem do rohu

	# otočení
	if character_direction.x > 0:
		%animace.flip_h = false
	elif character_direction.x < 0:
		%animace.flip_h = true

	# pohyb 
	if character_direction:
		velocity = character_direction * movementSpeed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movementSpeed)

	move_and_slide()
	check_XP()
	damage_animation()

func damage_animation():
	if %hurtBox.get_overlapping_bodies().size() > 0:
		return

	if character_direction:
		if %animace.animation != "runRed":
			%animace.play("runRed")
	else:
		if %animace.animation != "idleRed":
			%animace.play("idleRed")

	if health <= 0.0:
		health_depleted.emit()
		
func gain_XP(amount):
	XP += amount
	total_XP += amount
	
func check_XP():
	if XP > $XpBar.max_value:
		XP -= $XpBar.max_value
		level += 1


func _on_magnet_area_entered(area):
	if area.has_method("follow"):
		area.follow(self)
	
