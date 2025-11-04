extends Node

@export var player: Node2D
@export var bee_scene: PackedScene
@export var snail_scene: PackedScene
@export var boar_scene: PackedScene
@export var spawn_radius: float = 500.0
@export var max_enemies: int = 10
@export var spawn_interval: float = 2.0

var enemies: Array = []
var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval and enemies.size() < max_enemies:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy() -> void:
	var enemy_scene: PackedScene

	# Randomly pick enemy type
	var roll = randi() % 3
	if roll == 0 and bee_scene:
		enemy_scene = bee_scene
	elif roll == 1 and snail_scene:
		enemy_scene = snail_scene
	elif roll == 2 and boar_scene:
		enemy_scene = boar_scene
	else:
		return  # No valid scene available

	# Instantiate and add to the scene
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.player = player

	# Random spawn around player
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	enemy.global_position = player.global_position + offset

	# Track enemy
	enemies.append(enemy)
	enemy.connect("tree_exited", Callable(self, "_on_enemy_died").bind(enemy))

func _on_enemy_died(enemy: Node) -> void:
	enemies.erase(enemy)
