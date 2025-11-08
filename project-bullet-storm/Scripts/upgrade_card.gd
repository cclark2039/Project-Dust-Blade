extends Panel

signal upgrade_selected

@export var icon: CompressedTexture2D
@export var description : String
@export var upgrade : Global.upgrades


func _ready(): 
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label. text = description
	
func apply_upgrade(): 
	var upgradeNumber = int(description.split(" ")[0].replace("+", "").replace ("%", ""))
	
	Global.add_upgrade(upgrade, upgradeNumber)
	
	upgrade_selected.emit()
