extends CharacterBody2D

signal health_depleted

var health = 100.0
var damageRate := 25.0

@export var movementSpeed : float = 100.0
@onready var healthBar = $HealthBar


var character_direction : Vector2

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

	var overlapping_mobs = %hurtBox.get_overlapping_bodies()

	if overlapping_mobs.size() > 0:
		# dostávám damage → hurt
		health -= damageRate * overlapping_mobs.size() * delta
		healthBar.value = health

		if %animace.animation != "hurt":
			%animace.play("hurt")
	else:
		# nedostávám damage → run / idle
		if character_direction:
			if %animace.animation != "runRed":
				%animace.play("runRed")
		else:
			if %animace.animation != "idleRed":
				%animace.play("idleRed")

	if health <= 0.0:
		health_depleted.emit()
