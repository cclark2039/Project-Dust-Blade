extends CharacterBody2D

const SPEED = 1000.0
@onready var animatedSprite = $AnimatedSprite2D
@onready var attackHitbox = $AttackHitbox
@onready var attackShape = $AttackHitbox/CollisionShape2D
var is_attacking = false

func _ready() -> void:
	# Disable attack hitbox initially
	attackHitbox.monitoring = false
	attackShape.disabled = true
	attackHitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))

func _physics_process(delta: float) -> void:
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")

	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		start_attack()

	if directionx or directiony:
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
		if not is_attacking:
			animatedSprite.play("Run")
		if directionx >= 0:
			animatedSprite.flip_h = false
		else:
			animatedSprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if not is_attacking:
			animatedSprite.play("Idle")

	move_and_slide()

func start_attack() -> void:
	is_attacking = true
	attackHitbox.monitoring = true
	attackShape.disabled = false
	animatedSprite.play("Attack")
	await animatedSprite.animation_finished
	attackHitbox.monitoring = false
	attackShape.disabled = true
	is_attacking = false
	animatedSprite.play("Idle")

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
