extends CharacterBody2D

var health = 3

@onready var an = $animace
@onready var player = get_node("/root/game/player")

func _ready():

	an.play("move")


func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 30.0
	move_and_slide()

func take_damage():
	health -= 1
	an.play("hurt")
	await an.animation_finished
	an.play("move")
	
	if health == 0:
		an.play("smoke")
		await an.animation_finished
		queue_free()
