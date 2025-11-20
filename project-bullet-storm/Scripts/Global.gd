extends Node


#Global variables go here
var show_upgrades = false
var score_required_upgrade = 800

var score = 0
var base_score = 800
var score_level = 1
var current_level = 1

#upgrade stats
var addHealth = 0
var dmgMulti = 0
var attackSpeedMulti = 0
var heal_amount = 0
var heal = false

#upgrades code
signal stats_updated

enum Upgrades {ADD_DAMAGE, ADD_ATTACK_SPEED, ADD_HEALTH, RAND_HEAL} #Add more to this

#currently stats is either 1  or 10. Not fully implemented for player (WIP)
func add_upgrade(upgrade: Upgrades, value: float):
	match upgrade:
		Upgrades.ADD_DAMAGE:
			dmgMulti += value / 100 #(10%)
		Upgrades.ADD_ATTACK_SPEED:
			attackSpeedMulti += value / 100.0 #10%
		Upgrades.ADD_HEALTH:
			addHealth = value
		Upgrades.RAND_HEAL: 
			heal = true
	stats_updated.emit()

func reset():
	score = 0
	addHealth = 0
	dmgMulti = 0.0
	attackSpeedMulti = 0.0

func apply_upgrades_to_player(player):
	randomize()
	# Health upgrade
	player.max_health += addHealth
	print("Player Max Health upgraded to: ", player.max_health)
	if heal == true:
		player.current_health += randi_range(5, 25)
		if player.current_health > player.max_health: 
			player.current_health = player.max_health
		heal = false
	
	#player.current_health = min(player.current_health, player.max_health)
	print("Player health updated to: ", player.current_health)
	if player.healthbar:
		player.healthbar.max_value = player.max_health
		player.healthbar.damage_bar.max_value = player.max_health
		player.healthbar.damage_bar.value = player.current_health
		player.healthbar.health = player.current_health
	addHealth = 0
	# Damage upgrade
	player.damage = player.base_damage * (1.0 + dmgMulti)
	print("Player damage upgraded to: ", player.damage)
	# ATKSPD Upgrade
	player.attack_speed = player.base_attack_speed * (1.0 + attackSpeedMulti)
	print("Player ATKSPD upgraded to: ", player.attack_speed)
