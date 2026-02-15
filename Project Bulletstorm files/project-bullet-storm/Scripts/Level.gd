extends Label

func _process(_delta: float) -> void: 
	text = "Level: %d"  %Global.current_level


#disabled until fixed or healthbar is moved to UI
