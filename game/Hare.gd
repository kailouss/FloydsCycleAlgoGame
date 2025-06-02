#Hare.gd
extends CharacterBody2D
const TILE_SIZE = 32
const SPEED = 2
const MOVE_DURATION = 0.3
var PHASE := 1
@onready var tilemap: TileMap = get_node("/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/TileMap")
@onready var tortoise = get_node("/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/Tortoise")
@onready var move_tween: Tween

# Long pressing
var is_moving := false
var current_direction := Vector2.ZERO
var move_cooldown := false

# Tortoise headstart
@onready var countdown_label: Label = get_node("/root/Main/HUD/HareCountdownLabel")
var countdown_time := 15
var can_move: bool = false

#2nd Phase
var is_second_phase: bool = false
var original_position: Vector2

func _ready():
	original_position = _snap_to_grid(position)
	position = original_position

func _snap_to_grid(pos: Vector2) -> Vector2:
	return (pos / TILE_SIZE).floor() * TILE_SIZE + Vector2(TILE_SIZE/2, TILE_SIZE/2)

func start_countdown():
	countdown_label.visible = true

	for i in range(countdown_time, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	can_move = true
	countdown_label.text = "HUNT!!!"
	await get_tree().create_timer(1.0).timeout
	countdown_label.visible = false
	
func _physics_process(_delta):
	if !can_move:
		return
	if not is_moving and not move_cooldown and current_direction != Vector2.ZERO:
		try_move(current_direction)

func _input(event):
	if event.is_action_pressed("hare_right"): current_direction.x = 1
	if event.is_action_pressed("hare_left"): current_direction.x = -1
	if event.is_action_pressed("hare_down"): current_direction.y = 1
	if event.is_action_pressed("hare_up"): current_direction.y = -1
	
	if event.is_action_released("hare_right") and current_direction.x == 1: current_direction.x = 0
	if event.is_action_released("hare_left") and current_direction.x == -1: current_direction.x = 0
	if event.is_action_released("hare_down") and current_direction.y == 1: current_direction.y = 0
	if event.is_action_released("hare_up") and current_direction.y == -1: current_direction.y = 0

func try_move(direction: Vector2):
	var move_distance := 1 if is_second_phase else SPEED
	for i in range(1, move_distance  + 1):
		var check_pos = position + (direction * i * TILE_SIZE)
		if !_is_tile_walkable(check_pos):
			move_distance = i - 1
			break
	
	if move_distance > 0:
		is_moving = true
		move_cooldown = true
		var target_pos = _snap_to_grid(position + direction * move_distance * TILE_SIZE)
		move_tween = create_tween()
		move_tween.tween_property(self, "position", target_pos, MOVE_DURATION).set_trans(Tween.TRANS_QUAD)
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
	var hare_tile = tilemap.local_to_map(position)
	var tortoise_tile = tilemap.local_to_map(tortoise.position)
	if hare_tile == tortoise_tile:
		get_node("/root/Main/GameManager")._on_hare_caught_tortoise()
		
func second_phase():
	position = original_position
	can_move = false
	is_second_phase = true
	await get_tree().create_timer(1.0).timeout
	can_move = true
	
func reset():
	is_second_phase = false
	can_move = false
	position = original_position
	is_moving = false
	current_direction = Vector2.ZERO
	move_cooldown = false

