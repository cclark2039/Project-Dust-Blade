extends CharacterBody2D


const SPEED = 1000.0
@onready var animatedSprite = $AnimatedSprite2D
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directionx or directiony:
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
		animatedSprite.play("run")
		if directionx >= 0:
			animatedSprite.flip_h = false # Face right
		else:
			animatedSprite.flip_h = true # Face left
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animatedSprite.play("idle")
		
	move_and_slide()
