extends "res://Scripts/enemy_base.gd"

@export var speed: float = 100.0

func _ready() -> void:
	max_health = 2
	current_health = max_health

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		flip_toward_player()
