extends Pickups
class_name Xp

@export var XP : float

func activate():
	super.activate()
	prints("+" +str(XP) + "XP")
	player_reference.gain_XP(XP)
