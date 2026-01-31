extends CharacterBody2D

var health = 50.0
var speed = 30.0
var damage = 20.0

@onready var an = $animace
@onready var player = get_node("/root/game/player")
const xp_scene = preload("res://xp.tscn")

func _ready():
	an.play("move")
	add_to_group("slimes")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction.normalized() * speed  # opravuje 2x rychlost když jdeš směrem do rohu
	move_and_slide()

func take_damage():
	health -= player.damage
	
	if health <= 0:
		var death_position = global_position 
		
		xp_drop(death_position)
		an.play("smoke")
		await an.animation_finished
		
		velocity = Vector2.ZERO
		queue_free()
		return
		
	an.play("hurt")	
	await an.animation_finished
	an.play("move")

	
func xp_drop(pos: Vector2):
	call_deferred("_spawn_xp", pos)

func _spawn_xp(pos: Vector2):
	var xp = xp_scene.instantiate()
	get_parent().get_parent().add_child(xp)
	xp.global_position = pos
