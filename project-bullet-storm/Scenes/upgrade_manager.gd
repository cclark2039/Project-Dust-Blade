extends Node

@export var Upgrade_Scene : PackedScene
var hold = false

func _process(_delta: float): 
	if Global.score % 1000 == 0 and hold == false and Global.score != 0: 
		hold = true
		var Upgrade = Upgrade_Scene.instantiate()
		add_child(Upgrade)
