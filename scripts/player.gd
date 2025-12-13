extends CharacterBody2D

signal health_depleted

var health = 100.0

@export var movement_speed : float = 100.0
@onready var health_bar = $Bar

var character_direction : Vector2

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	#otočení
	if character_direction.x > 0: %animace.flip_h = false
	elif character_direction.y < 0:%animace.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if %animace.animation != "run": %animace.animation = "run"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %animace.animation != "idle": %animace.animation = "idle"
	
	move_and_slide()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %hurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		health_bar.value = health
		#%ProgressBar.value = 500 - můžu nastavi maximální životy
		if health <= 0.0:	
			health_depleted.emit()
			
