extends Node

onready var start_button : Button = find_node("Start")
onready var exit_button : Button = find_node("Exit")
onready var music_toggle : CheckButton = find_node("MusicToggle")

func _ready():
	Checkpoints.clear()
	get_tree().paused = false
	music_toggle.pressed = Checkpoints.music
	start_button.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		_on_Exit_pressed()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	get_tree().change_scene("res://main.tscn")



func _on_MusicToggle_toggled(button_pressed):
	Checkpoints.music = music_toggle.pressed
