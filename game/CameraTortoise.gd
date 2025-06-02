#CameraTortoise.gd
extends Camera2D

@onready var tilemap: TileMap = get_node("/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/TileMap")

func _ready():
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	var world_size = map_rect.size * tile_size
	
	limit_left = 0
	limit_top = 0
	limit_right = world_size.x
	limit_bottom = world_size.y
	reset_smoothing()
	zoom = Vector2(3, 3)
