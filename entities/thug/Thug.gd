extends KinematicBody2D

export var money = 100

var jumping = false
var velocity = Vector2()
var starting_x
var direction = Vector2.LEFT
export var wander_range = [ -100, 100 ]
export var speed = 100

var r = RandomNumberGenerator.new()


var MoneyBag = load("res://entities/pickups/MoneyBag.tscn")
var Bomb = load("res://entities/thug/Bomb.tscn")

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	r.randomize()
	starting_x = position.x

func _on_body_entered(object):
	if object.is_in_group("player"):
		$Poof.activate()
		object.add_wealth(money)
		queue_free()
	if object.is_in_group("player_projectiles"):
		object.poof() #I shouldn't need to do this here, but I do for some reason
		call_deferred("_drop_loot_and_die")

func _drop_loot_and_die():
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
	var pos = position.x - starting_x
	if pos < wander_range[0] or pos > wander_range[1]:
		direction *= -1
	velocity.x = speed * direction.x
	if r.randf() > 0.98:
		_toss_bomb()

func _toss_bomb():
	var projectile = Bomb.instance()
	get_tree().root.add_child(projectile)
	projectile.global_position = global_position
	projectile.linear_velocity = velocity
	projectile.apply_central_impulse(100 * Vector2(direction.x, -1).normalized())