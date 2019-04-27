extends KinematicBody2D

export var money = 100

var jumping = false
var velocity = Vector2()

var MoneyBag = load("res://entities/pickups/MoneyBag.tscn")

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(object):
	if object.is_in_group("player"):
		$Poof.activate()
		object.add_wealth(money)
		queue_free()
	if object.is_in_group("player_projectiles"):
		object.poof() #I shouldn't need to do this here...
		var bag = MoneyBag.instance()
		get_tree().root.add_child(bag)
		bag.global_position = global_position
		bag.linear_velocity = velocity
		bag.money = money
		queue_free()

func _physics_process(delta):
	_artificial_stupidity(delta)

	if jumping:
		move_and_slide(velocity, Vector2.UP)
	else:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y += 9.81
		move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func _artificial_stupidity(delta):
	pass