#Main.gd
extends Node

func _ready():
	$Menu.visible = true
	$Game.visible = false
	$HUD/PreGameMessagePanel.visible = false
