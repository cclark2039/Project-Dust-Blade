extends CharacterBody2D

@export var max_health: int = 3
var current_health: int
@export var player: Node2D
@onready var animatedSprite = $AnimatedSprite2D

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int = 1) -> void:
	current_health -= amount
	if current_health <= 0:
		die()

func die() -> void:
	queue_free()

# Common flipping logic for enemies chasing player
func flip_toward_player():
	if not player:
		return
	if player.global_position.x >= global_position.x:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
