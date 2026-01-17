extends Node2D


@onready var path_follow = %PathFollow2D
@onready var timer = $GlobalTimer
@onready var healthTimer = $IncreseHealthTimer
@onready var player = get_node("/root/game/player")

var slimeHealthBonus := 0
var slimeSpeedBonus := 0

var maxSlimes := 5
var currentSlimes := 0

var is_paused := false

func _process(_delta):
	if Input.is_action_just_pressed("pause_menu"):
		is_paused = true
		get_tree().paused = true
		$PauseMenu.visible = true

		
func spawn_mob():
	if currentSlimes >= maxSlimes:
		return
		
	var mob = preload("res://slime.tscn").instantiate()
	path_follow.progress_ratio = randf()
	mob.global_position = path_follow.global_position
	
	mob.health += slimeHealthBonus
	mob.speed += slimeSpeedBonus
	

	add_child(mob)
	currentSlimes += 1
	
	# Po zničení slima se počet sníží
	mob.tree_exited.connect(_on_slime_removed)

func _on_slime_removed():
	currentSlimes -= 1
	
func _on_global_timer_timeout() -> void:
	spawn_mob()	

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_button_try_again_pressed() -> void:
	Input.flush_buffered_events()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_increse_health_timer_timeout() -> void:
	slimeHealthBonus += 2
	slimeSpeedBonus += 5.0
	maxSlimes += 2
	player.damageRate += 5.0

func _on_button_quit_game_pressed() -> void:
	Input.flush_buffered_events() # odstraní předochí zobrazení zakliknutí tlačítka	
	get_tree().quit()
	

func _on_button_restart_pressed() -> void:
	Input.flush_buffered_events()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_button_resume_pressed() -> void:
	Input.flush_buffered_events()
	is_paused = false
	get_tree().paused = false
	$PauseMenu.visible = false
	

#přidej po dalším zmáčkutí tabu tak se zase zpustí hra
#dodělej text když se zvíší obtížnost
