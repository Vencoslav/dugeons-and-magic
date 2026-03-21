extends HSlider

@export var audioBusName: String

var audioBusId

func _ready() -> void:
	audioBusId = AudioServer.get_bus_index(audioBusName)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audioBusId,db)
