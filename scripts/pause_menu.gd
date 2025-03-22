extends Control

@onready var blur: AnimationPlayer = $blur

func _ready():
	blur.play("RESET")
	hide()

func resume():
	get_tree().paused = false
	blur.play_backwards("blur")
	hide()

func pause():
	get_tree().paused = true
	blur.play("blur")
	show()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()


func _on_resume_pressed() -> void:
	resume()

func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
