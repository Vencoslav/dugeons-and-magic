extends CharacterBody2D

signal health_depleted

var health = 100.0

@export var movement_speed : float = 100.0
@onready var health_bar = $Bar


var character_direction : Vector2

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized() # opravuje 2x rychlost když jdeš směrem do rohu

	# otočení
	if character_direction.x > 0:
		%animace.flip_h = false
	elif character_direction.x < 0:
		%animace.flip_h = true

	# pohyb 
	if character_direction:
		velocity = character_direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

	move_and_slide()

	const DAMAGE_RATE = 25.0
	var overlapping_mobs = %hurtBox.get_overlapping_bodies()

	if overlapping_mobs.size() > 0:
		# dostávám damage → hurt
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		health_bar.value = health

		if %animace.animation != "hurt":
			%animace.play("hurt")
	else:
		# nedostávám damage → run / idle
		if character_direction:
			if %animace.animation != "run":
				%animace.play("run")
		else:
			if %animace.animation != "idle":
				%animace.play("idle")

	if health <= 0.0:
		health_depleted.emit()
