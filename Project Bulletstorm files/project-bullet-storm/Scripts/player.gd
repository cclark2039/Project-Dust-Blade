extends CharacterBody2D

class_name Player
signal died

var base_damage: int = 1
var base_attack_speed: float = 1.0
var max_health: int = 100
var current_health: int = max_health

const SPEED = 1000.0
var is_attacking = false
var is_in_space = false

var damage: float = base_damage
var attack_speed: float = base_attack_speed

@onready var animatedSprite = $AnimatedSprite2D
@onready var attackHitbox = $AttackHitbox
@onready var attackShape = $AttackHitbox/CollisionShape2D
@onready var healthbar = $HealthBar
# Audio properties
@onready var attack_sound = $AttackSound  # Add AudioStreamPlayer2D node
@onready var hurt_sound = $HurtSound      # Add AudioStreamPlayer2D node
@onready var death_sound = $DeathSound    # Add AudioStreamPlayer2D node
@onready var music = $Background_music

func _ready() -> void:
	# Disable attack hitbox initially
	attackHitbox.monitoring = false
	attackShape.disabled = true
	attackHitbox.connect("body_entered", Callable(self, "_on_attack_hitbox_body_entered"))
	Global.stats_updated.connect(_on_global_upgrades_changed)
	healthbar.init_health(max_health)
	Global.apply_upgrades_to_player(self)
	music.play()
	
	
func _physics_process(_delta: float) -> void:
	# Check for death
	if current_health <= 0:
		play_sound(death_sound, 1)
		set_physics_process(false)
		await get_tree().create_timer(1.3).timeout
		die()
		return
		
	handle_movement()
	handle_attack()
	
func handle_movement():
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		if not is_attacking:
			animatedSprite.play("Run")
		animatedSprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		if not is_attacking:
			animatedSprite.play("Idle")
	move_and_slide()
		
func handle_attack():
	if Input.is_action_just_pressed("ui_select") and not is_attacking:
		start_attack()

func start_attack() -> void:
	is_attacking = true
	attackHitbox.monitoring = true
	attackShape.disabled = false
	
	# stores the speed of the animation so that animation speed can be reset after attack animation
	# increases the attack speed animation = attack speed
	var original_speed = animatedSprite.speed_scale
	animatedSprite.speed_scale = attack_speed
	animatedSprite.play("Attack")
	play_sound(attack_sound, 5)
	
	# resets animation speed
	await animatedSprite.animation_finished
	animatedSprite.speed_scale = original_speed
	
	attackHitbox.monitoring = false
	attackShape.disabled = true
	is_attacking = false
	animatedSprite.play("Idle")
	
func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	play_sound(hurt_sound, 2)
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	if current_health <= 0:
		die()
	if healthbar:
		healthbar.health = current_health

func _on_attack_hitbox_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	
func die():
	emit_signal("died")
	hide()
	set_physics_process(false)
	if get_tree().current_scene.has_method("_on_player_died"):
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
			
func _on_die_box_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		is_in_space = true
		while (is_in_space == true and current_health > 0):
			take_damage(1)
			play_sound(hurt_sound, 2)
			modulate = Color.RED
			await get_tree().create_timer(0.1).timeout
			modulate = Color.WHITE
			await get_tree().create_timer(1).timeout

func _on_die_box_body_exited(body: Node2D) -> void:
	if body.has_method("die"):
		is_in_space = false
	
func _on_global_upgrades_changed():
	Global.apply_upgrades_to_player(self)
