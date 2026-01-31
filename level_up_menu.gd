extends CanvasLayer

@onready var container = $ColorRect/Container

@export var possible_upgrades: Array[PackedScene]  # sem dej všechny upgrady

func show_options():
	clear_options()
	visible = true
	get_tree().paused = true

	possible_upgrades.shuffle()
	for i in range(3):
		var option = possible_upgrades[i].instantiate()
		container.add_child(option)

func clear_options():
	for child in container.get_children():
		child.queue_free()
