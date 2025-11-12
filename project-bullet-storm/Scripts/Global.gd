extends Node

#Global variables go here
var show_upgrades = false
var score_required_upgrade = 500

var score = 0

#upgrade stats
var addHealth = 0
var dmgMulti = 0
var attackSpeedMulti = 0

#upgrades code
signal stats_updated

enum Upgrades {ADD_DAMAGE, ADD_ATTACK_SPEED, ADD_HEALTH} #Add more to this

#currently stats is either 1  or 10. Not fully implemented for player (WIP)
func add_upgrade(upgrade: Upgrades, value: float):
	match upgrade:
		Upgrades.ADD_DAMAGE:
			dmgMulti += value / 100.0
		Upgrades.ADD_ATTACK_SPEED:
			attackSpeedMulti += value / 100.0
		Upgrades.ADD_HEALTH:
			addHealth += value
	stats_updated.emit()

func reset():
	score = 0
	addHealth = 0
	dmgMulti = 0.0
	attackSpeedMulti = 0.0

func apply_upgrades_to_player(player):
	player.max_health += addHealth
	player.damage = player.base_damage * (1.0 + dmgMulti)
	player.attack_speed = player.base_attack_speed * (1.0 + attackSpeedMulti)
