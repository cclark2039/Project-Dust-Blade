extends Label

@export var player : Player

func _process(_delta: float) -> void:
	if player:
		text = "Health: %d" % player.current_health
