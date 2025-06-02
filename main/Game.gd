extends Node2D

func _ready():
	var world = $HBoxContainer/TortoiseContainer/SubViewport.find_world_2d()
	$HBoxContainer/HareContainer/SubViewport.world_2d = world

func _process(delta):
	pass
	
