#ClearBlindnessSkill
extends Node

@onready var darkness_modulate = get_node("/root/Main/Game/HBoxContainer/TortoiseContainer/SubViewport/WorldTortoise/TileMap/CanvasModulate")
@onready var cooldown_label = get_node("/root/Main/HUD/SkillCooldownLabel")
var is_ready: bool = true
var original_color : Color
const TOGGLE_DURATION := 1.0
const COOLDOWN_DURATION := 5.0

func _ready():
	original_color = darkness_modulate.color
	#cooldown_label.visible = false

func _input(event):
	if event.is_action_pressed("clear_vision") and is_ready:
		clear_vision_once()
		
func clear_vision_once() -> void:
	if not is_ready:
		print("Cooldown active")
		return
	is_ready = false
	darkness_modulate.color = Color(1, 1, 1, 1)
	cooldown_label.visible = false
	await get_tree().create_timer(TOGGLE_DURATION).timeout
	cooldown_label.visible = true
	darkness_modulate.color = original_color
	var remaining := COOLDOWN_DURATION
	while remaining > 0:
		cooldown_label.text = "Skill CD: %d" % remaining
		await get_tree().create_timer(1.0).timeout
		remaining -= 1
	cooldown_label.visible = false
	
	is_ready = true
