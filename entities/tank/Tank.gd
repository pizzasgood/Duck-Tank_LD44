extends KinematicBody2D


export var max_speed = 200
export var rocket_thrust = 10
export var max_rocket_speed = 200
var velocity = Vector2()

var starting_funds = 500
var wealth = starting_funds
var idle_consumption = 10
var drive_consumption = 20
var rocket_consumption = 100
var gun_consumption = 50
var gun_efficiency = 0.9

var max_barrel_angle = 3.0/8.0 * PI
var min_barrel_angle = -1.0/8.0 * PI

export var projectile_impulse = 500

var rocket_active = false
var can_fire = false #cannon starts off disabled; unlock at the Shop
var can_rocket = false #rocket starts off disabled; unlock... SOMEWHERE

var CashWad = load("res://entities/tank/CashWad.tscn")


onready var main_body = find_node("MainBody")
onready var barrel = find_node("Barrel")
onready var barrel_end = find_node("BarrelEnd")
onready var exhaust_pipe = find_node("ExhaustPipe")
onready var idle_exhaust = find_node("IdleExhaust")
onready var drive_exhaust = find_node("DriveExhaust")
onready var rocket_exhaust = find_node("RocketExhaust")
onready var snd_rocket = find_node("SndRocket")

func _ready():
	if Checkpoints.available() and Checkpoints.player_data:
		load_data(Checkpoints.player_data)
	rocket_exhaust.emitting = false
	drive_exhaust.emitting = false

func _process(delta):
	if wealth <= 0:
		main_body.modulate = Color(1, 0, 0, 1)
		call_deferred("_die") #gives the GUI time to update first

func _die():
	get_tree().get_current_scene().find_node("GameOver").activate()

func _physics_process(delta):
	_handle_input()

	if rocket_active:
		move_and_slide(velocity, Vector2.UP)
		if is_on_ceiling():
			velocity.y = 0
	else:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity.y += 9.81
		move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	_burn_money_as_fuel(delta)

func _burn_money_as_fuel(delta):
	if velocity.x != 0:
		wealth -= delta * drive_consumption
		drive_exhaust.emitting = true
	else:
		drive_exhaust.emitting = false
	if rocket_active:
		wealth -= delta * rocket_consumption
		rocket_exhaust.emitting = true
		if not snd_rocket.playing:
			snd_rocket.play()
	else:
		rocket_exhaust.emitting = false
		if snd_rocket.playing:
			snd_rocket.stop()
	wealth -= delta * idle_consumption

func _handle_input():
	#left and right
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += max_speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= max_speed

	#using the rocket?
	if Input.is_action_pressed("jump") and can_rocket:
		rocket_active = true
		velocity.y = max(velocity.y - rocket_thrust, -max_rocket_speed)
	else:
		rocket_active = false

	#mirror tank?
	var mouse_pos = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
	main_body.flip_h = mouse_pos.x < global_position.x
	if (main_body.flip_h and barrel.position.x > 0) or (not main_body.flip_h and barrel.position.x < 0):
		barrel.position.x *= -1
		exhaust_pipe.position.x *= -1

	#tilt the barrel to aim at the mouse
	var d = mouse_pos - barrel.global_position
	if d.x == 0:
		d.x = 1 #avoid division by zero
	var angle = atan(d.y/abs(d.x))
	angle = min(max(angle, -max_barrel_angle), -min_barrel_angle)
	#barrel.look_at(mouse_pos)
	if mouse_pos.x < global_position.x:
		#mirror the angle around y axis
		angle = PI - angle
	barrel.global_rotation = angle

	#firing?
	if Input.is_action_just_pressed("fire") and can_fire:
		var projectile = CashWad.instance()
		get_tree().get_current_scene().add_child(projectile)
		projectile.linear_velocity = velocity
		projectile.global_transform = barrel_end.global_transform
		projectile.apply_central_impulse(projectile_impulse * (barrel_end.global_position - barrel.global_position).normalized())
		projectile.money = gun_consumption * gun_efficiency
		wealth -= gun_consumption
		can_fire = false
		$BarrelCooldown.start()
		find_node("SndShoot").play()

func get_wealth():
	return wealth

func add_wealth(gain):
	wealth += gain

func remove_wealth(loss):
	wealth -= loss

func damage(loss):
	remove_wealth(loss)
	find_node("SndHit").play()
	main_body.modulate = Color(1, 0, 0, 1)
	$DamageFlash.start()

func has_cannon():
	return barrel.visible

func has_rocket():
	return can_rocket

func activate_cannon():
	barrel.visible = true
	can_fire = true
	find_node("SndUpgrade").play()

func activate_rocket():
	can_rocket = true
	find_node("SndUpgrade").play()

func dump_data():
	var data = Dictionary()
	data['wealth'] = wealth
	data['global_position'] = global_position
	data['have_cannon'] = has_cannon()
	data['have_rocket'] = has_rocket()
	return data

func load_data(data):
	wealth = max(starting_funds, data['wealth'])
	global_position = data['global_position']
	if data['have_cannon']:
		activate_cannon()
	if data['have_rocket']:
		activate_rocket()

func _on_BarrelCooldown_timeout():
	can_fire = true

func _on_DamageFlash_timeout():
	main_body.modulate = Color(1, 1, 1, 1)


func _on_SndRocket_finished():
	if rocket_active:
		snd_rocket.play()

