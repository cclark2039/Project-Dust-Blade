extends Node2D

@onready var player = $Player
@onready var game_over_ui = $GameOver  # Assuming GameOver is a direct child
@onready var paused = $Paused

func _ready() -> void:
	# Hide game over UI at start
	game_over_ui.visible = false
	
	#Hide paused menu at start
	paused.visible = false
	
	# Connect to player's death
	if player.has_signal("died"):
		player.connect("died", _on_player_died)
		


func _on_player_died() -> void:
	game_over_ui.game_over()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().paused = true
		paused.visible = true
