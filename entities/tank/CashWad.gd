extends RigidBody2D

export var money = 10

var poofed = false

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(object):
	if object.is_in_group("enemy"):
		poof()
	if object.is_in_group("player"):
		$PoofP.activate()
		object.add_wealth(money)
		queue_free()

func poof():
	if not poofed:
		poofed = true
		$PoofE.activate()
		#queue_free()