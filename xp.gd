extends Area2D

@export var xp_amount : int = 100
@export var speed := 100.0

var player: CharacterBody2D
var following := false
var collected: bool = false

func _ready():
	connect("body_entered", _on_body_entered)

func _physics_process(delta):
	if following and player:
		global_position = global_position.move_toward(
			player.global_position,
			speed * delta
		)

func follow(target):
	player = target
	following = true
	
func _on_area_entered(area):
	if area.name == "Magnet":
		follow(area.get_parent())

# 🔹 SEBRÁNÍ XP
func _on_body_entered(body):
	if body.has_method("gain_XP"):
		body.gain_XP(xp_amount)
		queue_free()
