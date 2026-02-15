extends "res://Scripts/enemy_base.gd"

@export var speed: float = 100.0        # Normal walking speed
@export var run_speed: float = 300.0    # Charge speed
@export var charge_interval: float = 15.0
@export var charge_duration: float = 2.5
@export var idle_after_charge: float = 3.0

enum State { IDLE, WALK, RUN, HIT }
var state: State = State.IDLE

var charge_timer: float = 0.0
var charging: bool = false
var idle_timer: float = 0.0

func _ready() -> void:
	max_health = 3
	current_health = max_health
	state = State.IDLE
	super._ready()

func _physics_process(delta: float) -> void:
	if not player:
		return

	charge_timer += delta

	if charging:
		state = State.RUN
		move_toward_player(run_speed)
	elif idle_timer > 0.0:
		state = State.IDLE
		idle_timer -= delta
		if idle_timer <= 0.0:
			state = State.WALK
	elif direction_change == true: 
		state = State.HIT
		move_toward_player(speed)
	else:
		state = State.WALK
		move_toward_player(speed)
		if charge_timer >= charge_interval:
			start_charge()

func move_toward_player(current_speed: float) -> void:
	if player:
		if direction_change == false:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * current_speed
			move_and_slide()
			flip_toward_player()
		else: 
			var direction = (player.global_position - global_position).normalized()
			velocity = -direction * current_speed
			move_and_slide()
			flip_toward_player()

	match state:
		State.IDLE:
			animatedSprite.play("Idle")
		State.WALK:
			animatedSprite.play("Walk")
		State.RUN:
			animatedSprite.play("Run")
		State.HIT: 
			animatedSprite.play("Hit")

func start_charge() -> void:
	charging = true
	charge_timer = 0.0
	state = State.RUN
	await get_tree().create_timer(charge_duration).timeout
	charging = false
	idle_timer = idle_after_charge
	state = State.IDLE
