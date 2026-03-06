extends OptionButton

@onready var pixelGuntlet = get_node("/root/game/PixelGauntletB")
@onready var dungeonRush = get_node("/root/game/DungeonRushB")

func _on_item_selected(index: int) -> void:
	if index == 0:
		dungeonRush.play()
	elif index == 1:
		pixelGuntlet.play()
