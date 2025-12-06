extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/game/tilemap/player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 30.0
	move_and_slide()
	
func take_damage():
	health -= 1
	
	if health == 0:
		queue_free()
	
