extends CharacterBody2D

var health = 3

@onready var player = get_node("/root/game/tilemap/player")
@onready var an = $animace




func _ready() -> void:
	an.play("move")


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 30.0
	move_and_slide()
	

	
func take_damage():
	health -= 1
	an.play("hurt")
	
	await get_tree().create_timer(1.0).timeout # počká se 3 sekundy a pak se pustí animaci move
	an.play("move")
	
	if health == 0:
		queue_free()
	
