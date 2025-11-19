extends Node2D

@onready var player = $PlayerBS

@onready var paused = $Paused

func _ready() -> void:

	
	#Hide paused menu at start
	paused.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().paused = true
		paused.visible = true
