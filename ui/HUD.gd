extends CanvasLayer

@onready var seconds_label: Label = $Seconds
@onready var minutes_label: Label = $Minutes
@onready var announce_label: Label = $AnnounceLabel
var time: float = 90.0
var minutes: int = 0
var seconds: int = 0
var running := false


func _ready():
	$"/root/Main/GameManager".game_over.connect(_on_game_over)
	
func start_timer():
	time = 90.0
	running = true
	#$SkillCooldownLabel.visible = true
	#$SkillCooldownLabel.text = "Skill: V"

func _process(delta) -> void:
	if running:
		time = max(time - delta, 0)
		minutes = fmod(time, 3600) / 60
		seconds = int(fmod(time, 60))
		minutes_label.text = "%02d:" % minutes
		seconds_label.text = "%02d" % seconds

func _on_game_over(win: bool):
	running = false
	announce_label.text = "Cycle Detected!" if win else "No Cycle Detected!"
	await get_tree().create_timer(3.0).timeout
	$"/root/Main/Menu".visible = true
	$"/root/Main/Game".visible = false
	visible = false
	
func reset_timer():
	time = 90.0
	minutes = 0
	seconds = 0
	seconds_label.text = "00"
	minutes_label.text = "00:"
	running = false
	announce_label.text = ""

