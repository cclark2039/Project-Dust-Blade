extends Label

func _process(_delta: float) -> void:
	text = "Health: %d" % Global.health
