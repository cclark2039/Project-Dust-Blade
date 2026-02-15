extends Node

@export var player: Node2D
@export var bee_scene: PackedScene
@export var snail_scene: PackedScene
@export var boar_scene: PackedScene
# bosses
@export var bee_boss_scene: PackedScene
@export var big_boar_scene: PackedScene
@export var snail_boss_scene: PackedScene

@export var spawn_radius: float = 1000.0
@export var max_enemies: int = 15
@export var spawn_interval: float = 1.0

var enemies: Array = []
var spawn_timer: float = 0.0
var boss_spawned: bool = false

var bee_boss_spawned: bool = false
var big_boar_spawned: bool = false
var snail_boss_spawned: bool = false

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval and enemies.size() < max_enemies:
		spawn_enemy()
		spawn_timer = 0.0
		
	if Global.current_level >= 3 and not bee_boss_spawned:
		spawn_bee_boss()
		
	if Global.current_level >= 6 and not snail_boss_spawned:
		spawn_snail_boss()
		
	if Global.current_level >= 9 and not big_boar_spawned:
		spawn_big_boar()

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
	
func spawn_bee_boss():
	print("spawn bee boss")
	bee_boss_spawned = true
	
	if not bee_boss_scene:
		print("ERROR: bee_boss_scene is not here!")
		return
	var boss = bee_boss_scene.instantiate()
	add_child(boss)
	boss.player = player

	var offset = Vector2(spawn_radius, 0)
	boss.global_position = player.global_position + offset
	enemies.append(boss)
	boss.connect("tree_exited", Callable(self, "_on_bee_boss_died").bind(boss))
	
func spawn_snail_boss():
	print("spawn snail boss")
	snail_boss_spawned = true
	
	if not snail_boss_scene: 
		print("ERROR: snail_boss_scene is not here!")
		return
	var boss = snail_boss_scene.instantiate()
	add_child(boss)
	boss.player = player
	
	var offset = Vector2(spawn_radius, 0)
	boss.global_position = player.global_position + offset
	enemies.append(boss)
	boss.connect("tree_exited", Callable(self, "_on_snail_boss_died").bind(boss))

func spawn_big_boar():
	print("spawn big boar")
	big_boar_spawned = true
	
	if not big_boar_scene:
		print("ERROR: big_boar_scene is not here!")
		return
	var boss = big_boar_scene.instantiate()
	add_child(boss)
	boss.player = player
	
	var offset = Vector2(spawn_radius, 0)
	boss.global_position = player.global_position + offset
	enemies.append(boss)
	boss.connect("tree_exited", Callable(self, "_on_big_boar_died").bind(boss))
	
func _on_enemy_died(enemy: Node) -> void:
	enemies.erase(enemy)

func _on_bee_boss_died(boss: Node):
	enemies.erase(boss)
	print("Bee Boss defeated!")

func _on_snail_boss_died(boss: Node):
	enemies.erase(boss)
	print("Snail Boss defeated!")
	
func _on_big_boar_died(boss: Node):
	enemies.erase(boss)
	print("Big Boar defeated!")
