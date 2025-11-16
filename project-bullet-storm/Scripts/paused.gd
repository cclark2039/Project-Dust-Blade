extends CanvasLayer

func _on_continue_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
