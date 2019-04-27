extends CenterContainer

onready var resume_button : Button = find_node("Resume")
onready var exit_button : Button = find_node("Exit")

func _ready():
	pass


func _on_Exit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	visible = false
	get_tree().paused = false

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if visible:
			_on_Resume_pressed()
		else:
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