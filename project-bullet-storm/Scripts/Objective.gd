extends Area2D

@onready var panel = $Panel
@onready var label = $Panel/Label
@onready var next_button = $Panel/NextButton
@onready var back_button = $Panel/BackButton

var dialogue = [
	"Hello there!",
	"Welcome to this world.",
    "Good luck on your journey!"
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
