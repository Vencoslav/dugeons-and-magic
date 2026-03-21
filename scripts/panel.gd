extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0

func _process(delta: float) -> void:
	time += delta

	minutes = int(time / 60) % 60
	seconds = int(time) % 60

	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d" % seconds

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d" % [minutes, seconds]
	
