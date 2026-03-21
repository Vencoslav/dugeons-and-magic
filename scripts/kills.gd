extends Panel

@onready var kills_label: Label = $KillsLabel

func set_kills(value: int) -> void:
	kills_label.text = "Kills: " + str(value)
