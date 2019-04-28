extends Node2D

onready var sprite = find_node("AnimatedSprite")
var active = false
export var cost = 50

func _ready():
	set_state(Checkpoints.station == get_path())

func set_state(saved):
	if saved:
		active = true
		sprite.animation = "saved"
	else:
		active = false
		sprite.animation = "default"

func activate():
	Checkpoints.set_checkpoint(get_path())
	set_state(true)
	find_node("SndActivate").play()

func deactivate():
	set_state(false)
	if Checkpoints.station == get_path():
		Checkpoints.station = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if not active and body.get_wealth() > cost:
			body.remove_wealth(cost)
			activate()
