extends Area2D

@onready var panel = $Panel
@onready var label = $Panel/Label
@onready var next_button = $Panel/NextButton
@onready var back_button = $Panel/BackButton

var dialogue = [
	"Welcome, traveler…",
	"This town stands alone 
	against an endless nightmare. 
	Night after night, monsters 
	flood the streets,an unbroken 
	tide of claws, steel, and fury. 
	No rescuers are coming. 
	No survivors remain to greet you.",
	"But the world works on a 
	simple law: the more you destroy, 
	the stronger you become. 
	Each enemy defeated feeds 
	your resolve, sharpens your skill, 
	and pushes you one step closer 
	to standing against the monstrous 
	leaders that control the swarm.",
	"The siege will never stop… 
	but neither must you. 
	Fight, grow, and carve your legacy!"
]
var current_index = 0

func _ready():
	panel.visible = false
	next_button.connect("pressed", Callable(self, "_on_next_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBS:
		panel.visible = true
		update_label()

func _on_body_exited(body: Node2D) -> void:
	if body is PlayerBS:
		panel.visible = false

func _on_next_pressed():
	if current_index < dialogue.size() - 1:
		current_index += 1
		update_label()
	else:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_back_pressed():
	if current_index > 0:
		current_index -= 1
		update_label()

func update_label():
	label.text = dialogue[current_index]
