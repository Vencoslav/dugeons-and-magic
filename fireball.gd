extends Area2D

var travelled_distance = 0

const SPEED: int = 300
	
func _process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
		
func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
