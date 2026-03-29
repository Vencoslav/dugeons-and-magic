extends Area2D

@export var xp_amount := 0 
@export var speed := 100

var player: CharacterBody2D
var following := false

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if following and player:
		var game = get_tree().current_scene
		var bonus = game.xp_pickup_speed_bonus if "xp_pickup_speed_bonus" in game else 1.0
		var final_speed = speed * bonus
		
		global_position = global_position.move_toward(
			player.global_position,
			final_speed * delta
		)

func follow(target):
	player = target
	following = true

# Tuto funkci volá sliz při umírání
func set_xp_amount(amount: int):
	xp_amount = amount

func _on_area_entered(area):
	if area.name == "Magnet":
		follow(area.get_parent())

func _on_body_entered(body):
	if body.has_method("gain_XP"):
		body.gain_XP(xp_amount)
		queue_free()
