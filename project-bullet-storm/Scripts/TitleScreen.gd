extends CanvasLayer


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false
