#Tortoise.gd
extends CharacterBody2D
const TILE_SIZE = 32
const SPEED = 1
const MOVE_DURATION = 0.3
@onready var tilemap: TileMap = get_node("/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/TileMap")
@onready var hare = get_node("/root/Main/Game/HBoxContainer/HareContainer/SubViewport/WorldHare/Hare")
@onready var move_tween: Tween

var is_moving := false
var current_direction := Vector2.ZERO
var move_cooldown := false
var original_position: Vector2

func _ready():
	original_position = _snap_to_grid(position)
	position = original_position

func _snap_to_grid(pos: Vector2) -> Vector2:
	return (pos / TILE_SIZE).floor() * TILE_SIZE + Vector2(TILE_SIZE/2, TILE_SIZE/2)
	
func _physics_process(_delta):
	if not is_moving and not move_cooldown and current_direction != Vector2.ZERO:
		try_move(current_direction)

func _input(event):
	if event.is_action_pressed("tortoise_right"): current_direction.x = 1
	if event.is_action_pressed("tortoise_left"): current_direction.x = -1
	if event.is_action_pressed("tortoise_down"): current_direction.y = 1
	if event.is_action_pressed("tortoise_up"): current_direction.y = -1
	
	if event.is_action_released("tortoise_right") and current_direction.x == 1: current_direction.x = 0
	if event.is_action_released("tortoise_left") and current_direction.x == -1: current_direction.x = 0
	if event.is_action_released("tortoise_down") and current_direction.y == 1: current_direction.y = 0
	if event.is_action_released("tortoise_up") and current_direction.y == -1: current_direction.y = 0

func try_move(direction: Vector2):
	var target_pos = position + (direction * SPEED * TILE_SIZE)
	if _is_tile_walkable(target_pos):
		is_moving = true
		move_cooldown = true
		target_pos = _snap_to_grid(target_pos)
		move_tween = create_tween()
		move_tween.set_trans(Tween.TRANS_SINE)
		move_tween.tween_property(self, "position", target_pos, MOVE_DURATION)
		move_tween.tween_callback(_on_move_finished)
		await get_tree().create_timer(MOVE_DURATION * 0.8).timeout
		move_cooldown = false

func _on_move_finished():
	is_moving = false
	check_collision()

func _is_tile_walkable(pos: Vector2) -> bool:
	var tile_pos = tilemap.local_to_map(pos)
	var tile_data = tilemap.get_cell_tile_data(0, tile_pos)
	return tile_data == null

func check_collision():
	if position.distance_to(hare.position) < 5.0:
		get_node("/root/Main/GameManager")._on_hare_caught_tortoise()
		
func reset():
	position = original_position
	is_moving = false
	current_direction = Vector2.ZERO
	move_cooldown = false

