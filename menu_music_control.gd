extends OptionButton

@onready var pixelGuntlet = $MainMenu/PixelGauntletA
@onready var dungeonRush = $MainMenu/DungeonRushA

func _on_item_selected(index: int) -> void:
	pixelGuntlet.stop()
	dungeonRush.stop()

	if index == 0:
		pixelGuntlet.play()
		
	elif index == 1:
		dungeonRush.play()
		
