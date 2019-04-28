extends Area2D

export var text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
export var button_text = "OK"
export var oneshot = true
var viewed = false

onready var basic_dialog = get_tree().get_current_scene().find_node("BasicDialog")

func _ready():
	pass

func _on_PopupZone_body_entered(body):
	if not viewed or not oneshot:
		basic_dialog.msg(text, button_text)
	viewed = true
