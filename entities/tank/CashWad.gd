extends RigidBody2D

export var money = 10

var poofed = false
var speed = 0

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	speed = linear_velocity.length_squared()

func _on_body_entered(object):
	var snd_thud = find_node("SndThud")
	if snd_thud:
		snd_thud.volume_db = min(speed/10000, 15) - 15
		snd_thud.play()
	if object.is_in_group("enemy"):
		poof()
	if object.is_in_group("player"):
		var snd_bling = find_node("SndBling")
		if snd_bling:
			snd_bling.play()
		$PoofP.activate()
		object.add_wealth(money)
		queue_free()

func poof():
	if not poofed:
		poofed = true
		$PoofE.activate()
		#queue_free()