extends CharacterBody2D

@export var max_health: int = 4
var current_health: int
@export var player: Node2D
@export var direction_change = false
@onready var animatedSprite = $AnimatedSprite2D

@onready var healthbar = $HealthBar

func _ready() -> void:
	if current_health == 0:
		current_health = max_health
	if healthbar:
		healthbar.init_health(max_health)
		healthbar.health = current_health

func take_damage(amount: int = 1) -> void:
	current_health -= amount
	knock_back()
	if current_health <= 0:
		die()
	
	if healthbar:
		healthbar.health = current_health

func die() -> void:
	queue_free()
	Global.score += 100

# Common flipping logic for enemies chasing player
func flip_toward_player():
	if not player:
		return
	if player.global_position.x >= global_position.x:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false

#Function to control knockback when hit
func knock_back(): 
	direction_change = true
	animatedSprite.play("Hit")

	await get_tree().create_timer(1).timeout
	
	direction_change = false
	animatedSprite.play("Walk")
	
