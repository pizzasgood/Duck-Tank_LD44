extends KinematicBody2D

export var money = 100

export var can_throw = true
var jumping = false
var velocity = Vector2()
var starting_x
var direction = Vector2.LEFT
export var wander_range = [ -100, 100 ]
export var speed = 100
export var bomb_random_factor = 0.5 #chance per second
export var bomb_cooldown = 1

var r = RandomNumberGenerator.new()

onready var sprite = $Sprite

var MoneyBag = load("res://entities/pickups/MoneyBag.tscn")
var Bomb = load("res://entities/thug/Bomb.tscn")

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	set_bomb_cooldown(bomb_cooldown)
	r.randomize()
	starting_x = position.x

func set_bomb_cooldown(delay):
	bomb_cooldown = delay
	$BombCooldown.wait_time = bomb_cooldown

func _on_body_entered(object):
	if object.is_in_group("player"):
		find_node("SndOw").play()
		$Poof.activate()
		object.add_wealth(money)
		queue_free()
	if object.is_in_group("player_projectiles"):
		object.poof() #I shouldn't need to do this here, but I do for some reason
		call_deferred("_drop_loot_and_die")

func _drop_loot_and_die():
		var bag = MoneyBag.instance()
		get_tree().get_current_scene().add_child(bag)
		bag.global_position = global_position
		bag.linear_velocity = velocity
		bag.money = money
		var snd = find_node("SndOw")
		snd.get_parent().remove_child(snd)
		bag.add_child(snd)
		snd.global_position = global_position
		snd.play()
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

	sprite.flip_h = velocity.x > 0

func _artificial_stupidity(delta):
	var pos = position.x - starting_x
	if pos < wander_range[0]:
		direction = Vector2.RIGHT
	elif pos > wander_range[1]:
		direction = Vector2.LEFT
	velocity.x = speed * direction.x
	if can_throw and r.randf() / delta < bomb_random_factor:
		_toss_bomb()

func _toss_bomb():
	var projectile = Bomb.instance()
	get_tree().get_current_scene().add_child(projectile)
	projectile.global_position = global_position
	projectile.linear_velocity = velocity
	projectile.apply_central_impulse(100 * Vector2(direction.x, -1).normalized())
	can_throw = false
	$BombCooldown.start()

func _on_BombCooldown_timeout():
	can_throw = true
