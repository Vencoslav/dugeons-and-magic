extends Area2D

var travelled_distance = 0
var speed := 300

func _ready():
	add_to_group("fireball")
	
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
		
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free() 
