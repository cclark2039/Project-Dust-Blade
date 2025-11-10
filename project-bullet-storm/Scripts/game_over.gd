extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func game_over():
	get_tree().paused = true
	self.show()


func _on_button_pressed():
	Global.reset()  # reset stats
	get_tree().paused = false
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
