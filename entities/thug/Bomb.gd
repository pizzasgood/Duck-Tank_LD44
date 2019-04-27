extends RigidBody2D

export var damage = 500
onready var player = get_node("/root/main/Player")

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(object):
	if object.is_in_group("player") or object.is_in_group("player_projectiles"):
		explode()

func _on_Timer_timeout():
	explode()

func explode():
	$Timer.stop()
	$Poof.activate()
	if $AoE.overlaps_body(player):
		player.remove_wealth(damage)
	queue_free()
