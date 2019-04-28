extends CenterContainer

onready var resume_button : Button = find_node("Resume")
onready var exit_button : Button = find_node("Exit")
onready var music_toggle : CheckButton = find_node("MusicToggle")

func _ready():
	visible = false
	get_tree().get_current_scene().find_node("BGM").playing = Checkpoints.music #this isn't really the appropriate place for this, but am in a hurry


func _on_Exit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	visible = false
	get_tree().paused = false

func _unhandled_input(event):
	#define some debug controls
	if OS.is_debug_build():
		#manual savepoints are useful
		if event.is_action_pressed("ui_page_up"):
			#teleport to shop
			get_tree().get_nodes_in_group("player")[0].global_position = get_tree().get_current_scene().find_node("ShopZone").global_position
		if event.is_action_pressed("ui_end"):
			Checkpoints.set_checkpoint()
		if event.is_action_pressed("ui_home"):
			Checkpoints.restore_checkpoint()

	if event.is_action_pressed("menu"):
		if visible:
			_on_Resume_pressed()
		else:
			music_toggle.pressed = Checkpoints.music
			visible = true
			resume_button.grab_focus()
			get_tree().paused = true
	if visible:
		if event.is_action("menu") \
		  or event.is_action("ui_select") or event.is_action("ui_accept") or event.is_action("ui_cancel") \
		  or event.is_action("ui_focus_next") or event.is_action("ui_focus_prev") \
		  or event.is_action("ui_home") or event.is_action("ui_end") \
		  or event.is_action("ui_page_down") or event.is_action("ui_page_up") \
		  or event.is_action("ui_left") or event.is_action("ui_right") \
		  or event.is_action("ui_up") or event.is_action("ui_down"):
			get_tree().set_input_as_handled()


func _on_MusicToggle_toggled(button_pressed):
	Checkpoints.music = music_toggle.pressed
	get_node("/root/main/BGM").playing = Checkpoints.music
