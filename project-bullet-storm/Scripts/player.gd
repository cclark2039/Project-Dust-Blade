extends CharacterBody2D

signal died

const SPEED = 1000.0
@onready var animatedSprite = $AnimatedSprite2D
@onready var attackHitbox = $AttackHitbox
@onready var attackShape = $AttackHitbox/CollisionShape2D
var is_attacking = false
var is_in_space = false

# Audio properties
@onready var attack_sound = $AttackSound  # Add AudioStreamPlayer2D node
@onready var hurt_sound = $HurtSound      # Add AudioStreamPlayer2D node
@onready var death_sound = $DeathSound    # Add AudioStreamPlayer2D node

func _ready() -> void:
	# Disable attack hitbox initially
	attackHitbox.monitoring = false
	attackShape.disabled = true
	attackHitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))

func _physics_process(_delta: float) -> void:
	# Check for death
	if Global.health <= 0:
		play_sound(death_sound, 1)
		set_physics_process(false)
		await get_tree().create_timer(1.3).timeout
		die()
		return
	
	var directionx := Input.get_axis("ui_left", "ui_right")
	var directiony := Input.get_axis("ui_up", "ui_down")

	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		start_attack()

	if directionx or directiony:
		velocity.x = directionx * (SPEED)
		velocity.y = directiony * (SPEED)
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
	play_sound(attack_sound, 5)
	await animatedSprite.animation_finished
	attackHitbox.monitoring = false
	attackShape.disabled = true
	is_attacking = false
	animatedSprite.play("Idle")

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		

func _on_die_box_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		is_in_space = true
		while (is_in_space == true and Global.health > 0):
			Global.health -= 1
			play_sound(hurt_sound, 2)
			modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			modulate = Color.WHITE
			await get_tree().create_timer(1).timeout


func _on_die_box_body_exited(body: Node2D) -> void:
	if body.has_method("die"): 
		is_in_space = false

func die():
	# Emit the death signal
	emit_signal("died")
	# Disable the player
	set_physics_process(false)
	hide()
	get_tree().current_scene._on_player_died()
	
func play_sound(sound_player: AudioStreamPlayer2D, max_overlap := 3):
	if sound_player and sound_player.stream:
		# Count how many overlapping instances of this sound currently exist
		var current_instances = 0
		for child in get_children():
			if child is AudioStreamPlayer2D and child.stream == sound_player.stream and child.playing:
				current_instances += 1

		# Only allow if below the cap
		if current_instances < max_overlap:
			var new_sound = AudioStreamPlayer2D.new()
			new_sound.stream = sound_player.stream
			new_sound.volume_db = sound_player.volume_db
			new_sound.pitch_scale = sound_player.pitch_scale
			new_sound.position = sound_player.position
			add_child(new_sound)
			new_sound.play()
			new_sound.connect("finished", new_sound.queue_free)
