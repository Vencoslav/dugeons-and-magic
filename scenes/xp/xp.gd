extends Area2D

@export var xp_amount : int = 100
@export var speed := 100

var player: CharacterBody2D
var following := false
var collected: bool = false

func _ready():
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	if following and player:
		var game = get_tree().current_scene
		var final_speed = speed * game.xp_pickup_speed_bonus
		
		global_position = global_position.move_toward(
			player.global_position,
			final_speed * delta
		)

func follow(target):
	player = target
	following = true
	
func set_speed(new_speed: float):
	speed = new_speed

func _on_area_entered(area):
	if area.name == "Magnet":
		follow(area.get_parent())

func _on_body_entered(body):
	if body.has_method("gain_XP"):
		body.gain_XP(xp_amount)
		queue_free()
