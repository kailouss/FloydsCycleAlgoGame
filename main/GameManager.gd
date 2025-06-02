# GameManager.gd
extends Node
signal game_over(win: bool)
var current_phase := 1
var game_paused = false

func start_game():
	current_phase = 1
	await $"/root/Main/HUD/PreGameMessagePanel".show_pregame_message()
	$Timer.wait_time = 90
	$Timer.start()
	$Timer.timeout.connect(_on_timer_timeout, CONNECT_ONE_SHOT)
	$"/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare".start_countdown()
	await get_tree().create_timer(1.0).timeout
	$"/root/Main/HUD".start_timer()

	var hare = $"/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare"
	hare.can_move = false
	await get_tree().create_timer(15.0).timeout
	hare.can_move = true
	
func start_second_phase():
	game_paused = true
	if $Timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		$Timer.disconnect("timeout", Callable(self, "_on_timer_timeout"))
	$Timer.stop()
	$"/root/Main/HUD".reset_timer()
	await $"/root/Main/HUD/PreGameMessagePanel".show_2nd_phase_message()
	var hare = $"/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare"
	hare.second_phase()
	
	$Timer.start(90)
	$Timer.timeout.connect(_on_timer_timeout, CONNECT_ONE_SHOT)
	$"/root/Main/HUD".start_timer()
	game_paused = false

func _on_hare_caught_tortoise():
	if current_phase == 1:
		current_phase = 2
		start_second_phase()
	else:
		game_paused = true
		$Timer.stop()   
		emit_signal("game_over", true)
		await get_tree().create_timer(3.0).timeout
		
		var hare = $"/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare"
		hare.reset()
		var tortoise = $"/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/Tortoise"
		tortoise.reset()
		$"/root/Main/HUD".reset_timer()
		
		current_phase = 1

func _on_timer_timeout():
	if $"/root/Main/GameManager".game_paused:
		return
	emit_signal("game_over", false)
	await get_tree().create_timer(3.0).timeout
	var hare = $"/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare"
	hare.reset()
	var tortoise = $"/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/Tortoise"
	tortoise.reset()
	$"/root/Main/HUD".reset_timer()
	current_phase = 1
