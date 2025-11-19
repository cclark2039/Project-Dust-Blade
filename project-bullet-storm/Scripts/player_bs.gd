extends CharacterBody2D

class_name PlayerBS

const SPEED = 1000.0

@onready var animatedSprite = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	handle_movement()

func handle_movement():
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		animatedSprite.play("Run")
		animatedSprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		animatedSprite.play("Idle")

	move_and_slide()
