extends CharacterBody2D

var floor_rect := Rect2()  # bude nastaven při spawnu
var health = 3

@onready var an = $animace
@onready var player = get_node("/root/game/player")

func _ready():
	add_to_group("slimes")
	visible = false  # začíná skrytý
	an.play("move")

#tohle se stará o vidilenost 
func _process(_delta):
	if floor_rect.has_point(global_position):
		visible = true
	else:
		visible = false

func _physics_process(delta):
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
