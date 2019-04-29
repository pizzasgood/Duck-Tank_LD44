extends CenterContainer

onready var restart_button : Button = find_node("Restart")
onready var exit_button : Button = find_node("Exit")

func _ready():
	visible = false

func activate():
	get_tree().paused = true
	visible = true
	restart_button.grab_focus()

func _on_Restart_pressed():
	if Checkpoints.available():
		Checkpoints.restore_checkpoint()
		get_tree().paused = false
	else:
		get_tree().reload_current_scene()
		get_tree().paused = false

func _on_Title_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")

func _on_Exit_pressed():
	if OS.get_name() == "HTML5":
		#can't actually exit on HTML5, so return to title
		get_tree().change_scene("res://TitleScreen.tscn")
	else:
		get_tree().quit()


func _unhandled_input(event):
	if visible:
		if event.is_action("menu") \
		  or event.is_action("ui_select") or event.is_action("ui_accept") or event.is_action("ui_cancel") \
		  or event.is_action("ui_focus_next") or event.is_action("ui_focus_prev") \
		  or event.is_action("ui_home") or event.is_action("ui_end") \
		  or event.is_action("ui_page_down") or event.is_action("ui_page_up") \
		  or event.is_action("ui_left") or event.is_action("ui_right") \
		  or event.is_action("ui_up") or event.is_action("ui_down"):
			get_tree().set_input_as_handled()

