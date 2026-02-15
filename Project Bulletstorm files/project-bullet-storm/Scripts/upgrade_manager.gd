extends Node

@export var Upgrade_Scene : PackedScene

func _process(_delta: float): 
	if Global.score >= Global.score_required_upgrade and Global.show_upgrades == false and Global.score != 0: 
		Global.show_upgrades = true
		var Upgrade = Upgrade_Scene.instantiate()
		add_child(Upgrade)
		Global.score_level += 1
		Global.score_required_upgrade = Global.base_score * pow(Global.score_level, 1.4)
		Global.current_level += 1
