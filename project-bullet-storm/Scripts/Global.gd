extends Node

#Global variables go here
var show_upgrades = false
var score_required_upgrade = 500

var score = 0
var health = 100
var damage = 1
var attack_speed = 1

#upgrade stats
var addHealth = 0
var dmgMulti = 0
var attackSpeedMulti = 0


#upgrades code
signal stats_updated

enum upgrades {ADD_DAMAGE, ADD_ATTACK_SPEED, ADD_HEALTH} #Add more to this

#currently stats is either 1  or 10. Not fully implemented for player (WIP)
func add_upgrade(upgrade, stats):
	if upgrade == upgrades.ADD_DAMAGE:
		dmgMulti += stats/100 #10/100 = 0.1
		damage += (damage*dmgMulti) # damage + (damage*dmgMulti)
	elif upgrade == upgrades.ADD_ATTACK_SPEED:
		attackSpeedMulti += stats/100 #10/100 = 0.1
		attack_speed += (attack_speed*attackSpeedMulti) #attack_speed + (attack_speed*attackSpeedMulti)
	elif upgrade == upgrades.ADD_HEALTH: 
		health += stats
		
	
	stats_updated.emit()

func reset():
	score = 0
	health = 100
	damage = 1
	attack_speed = 1
	addHealth = 0
	dmgMulti = 0
	attackSpeedMulti = 0
