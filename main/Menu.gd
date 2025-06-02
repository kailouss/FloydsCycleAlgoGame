#Menu.gd
extends Control

@onready var main = get_node("/root/Main")

func _ready():
	$Panel/ButtonContainer/StartButton.pressed.connect(_on_start_pressed)
	$Panel/ButtonContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	main.get_node("Menu").visible = false
	main.get_node("Game").visible = true
	main.get_node("HUD").visible = true
	main.get_node("GameManager").start_game()

func _on_quit_pressed():
	get_tree().quit()

