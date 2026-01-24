extends Area2D

@export var xp_amount := 10
@export var speed := 200.0

var player: CharacterBody2D
var following := false

func _ready():
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	if following and player:
		global_position = global_position.move_toward(
			player.global_position,
			speed * delta
		)

func follow(target: CharacterBody2D):
	player = target
	following = true

func _on_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("gain_XP"):
			body.gain_XP(xp_amount)
		queue_free()
