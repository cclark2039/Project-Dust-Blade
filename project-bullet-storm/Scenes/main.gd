extends Node2D

@onready var player = $Player
@onready var game_over_ui = $GameOver  # Assuming GameOver is a direct child

func _ready() -> void:
	# Hide game over UI at start
	game_over_ui.visible = false
	
	# Connect to player's death
	if player.has_signal("died"):
		player.connect("died", _on_player_died)

func _on_player_died() -> void:
	game_over_ui.game_over()
