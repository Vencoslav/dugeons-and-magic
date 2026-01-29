extends TextureButton

@export var staff : staff:
	set(value):
		staff = value
	
		texture_mormal = value.texture
		$Label.text = "Lvl " + str(staff.level +1)


func _on_gui_input(event):
	pass
