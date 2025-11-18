extends "res://Scripts/enemy_base.gd"

@export var speed: float = 100.0

func _ready() -> void:
	max_health = 80
	current_health = max_health
	super._ready()

func _physics_process(_delta: float) -> void:
	if player:
		if direction_change == false:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			flip_toward_player()
		else: 
			var direction = (player.global_position - global_position).normalized()
			velocity = -direction * speed
			move_and_slide()
			flip_toward_player()
