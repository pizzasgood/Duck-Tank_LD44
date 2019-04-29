extends RigidBody2D

export var money = 100

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(object):
	if object.is_in_group("player"):
		var snd_bling = find_node("SndBling")
		if snd_bling:
			snd_bling.play()
		$Poof.activate()
		object.add_wealth(money)
		queue_free()
