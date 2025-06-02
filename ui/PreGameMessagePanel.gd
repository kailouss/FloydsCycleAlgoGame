extends Panel
@onready var message_label: Label = $PreGameMessage

func show_pregame_message():
	message_label.text = "The Tortoise has 15 seconds to run before the Hare hunts!"
	visible = true
	await get_tree().create_timer(5.0).timeout
	visible = false
	
func show_2nd_phase_message():
	message_label.text = "The Hare suddenly returns back to start and is exhausted...\nHunt the Tortoise again to confirm the cycle!"
	visible = true
	await get_tree().create_timer(5.0).timeout
	visible = false
