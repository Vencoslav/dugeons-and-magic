extends VBoxContainer

@export var possible_upgrades: Array[PackedScene]

func show_options():
	clear_options()

	get_tree().paused = true
	show()

	possible_upgrades.shuffle()

	for i in range(3):
		var option = possible_upgrades[i].instantiate()
		add_child(option)

func clear_options():
	for child in get_children():
		child.queue_free()

func close():
	hide()
	get_tree().paused = false
