extends CharacterBody2D

var health = 10
var speed = 30.0

@onready var an = $animace
@onready var player = get_node("/root/game/player")

func _ready():
	an.play("move")
	add_to_group("slimes")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
	velocity = velocity.normalized() # opravuje 2x rychlost když jdeš směrem do rohu


func take_damage():
	health -= 4
	an.play("hurt")
	await an.animation_finished
	an.play("move")
	
	
	if health == 0:
		an.play("smoke")
		await an.animation_finished
		queue_free()
