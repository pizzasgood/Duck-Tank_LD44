extends RigidBody2D

export var damage = 500
onready var player = get_tree().get_nodes_in_group("player")[0]
export var fuse = 2

func _ready():
	connect("body_entered", self, "_on_body_entered")
	set_fuse(fuse)

func set_fuse(seconds):
	fuse = seconds
	$Fuse.wait_time = fuse

func _on_body_entered(object):
	if object.is_in_group("player") or object.is_in_group("player_projectiles"):
		explode()

func _on_Timer_timeout():
	explode()

func explode():
	$Fuse.stop()
	find_node("SndBoom").play()
	$Poof.activate()
	if $AoE.overlaps_body(player):
		player.damage(damage)
	queue_free()
