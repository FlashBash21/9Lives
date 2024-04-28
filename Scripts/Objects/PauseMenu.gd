extends Control

var paused = false

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_cancel")):
		paused = !paused
		get_tree().paused = paused
		visible = paused
