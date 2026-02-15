extends Label

#Update every frame
func _process(_delta: float) -> void:
	text = "Score: %d" %Global.score
