extends Node2D

onready var label : Label = find_node("Label")
onready var button : Button = find_node("Button")

func _ready():
	visible = false

func msg(message, button_text = "OK"):
	get_tree().paused = true
	label.text = message
	button.text = button_text
	position = get_viewport().size / 2
	visible = true
	button.grab_focus()

func _on_Button_pressed():
	visible = false
	get_tree().paused = false
