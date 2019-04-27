extends KinematicBody2D


export var max_speed = 100
export var rocket_thrust = 10
export var max_rocket_speed = 200
var velocity = Vector2()

var fuel = 100
var idle_consumption = 10
var drive_consumption = 20
var rocket_consumption = 100
var gun_consumption = 50
var gun_efficiency = 0.9

var max_barrel_angle = 3.0/8.0 * PI
var min_barrel_angle = -1.0/8.0 * PI

export var projectile_impulse = 500

var rocket_active = false
var can_fire = true

var CashWad = load("res://entities/tank/CashWad.tscn")


onready var main_body = find_node("MainBody")
onready var barrel = find_node("Barrel")
onready var barrel_end = find_node("BarrelEnd")
onready var exhaust_pipe = find_node("ExhaustPipe")
onready var idle_exhaust = find_node("IdleExhaust")
onready var drive_exhaust = find_node("DriveExhaust")
onready var rocket_exhaust = find_node("RocketExhaust")


func _ready():
	pass # Replace with function body.

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
	_update_fuel(delta)

func _update_fuel(delta):
	if velocity.x != 0:
		fuel -= delta * drive_consumption
		drive_exhaust.emitting = true
	else:
		drive_exhaust.emitting = false
	if rocket_active:
		fuel -= delta * rocket_consumption
		rocket_exhaust.emitting = true
	else:
		rocket_exhaust.emitting = false
	fuel -= delta * idle_consumption

func _handle_input():
	#left and right
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += max_speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= max_speed

	#using the rocket?
	if Input.is_action_pressed("ui_up"):
		rocket_active = true
		velocity.y = max(velocity.y - rocket_thrust, -max_rocket_speed)
	else:
		rocket_active = false

	#get mouse stuff
	var mouse_pos = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
	var angle = global_position.angle_to_point(mouse_pos)

	#mirror tank?
	main_body.flip_h = mouse_pos.x < global_position.x
	if (main_body.flip_h and barrel.position.x > 0) or (not main_body.flip_h and barrel.position.x < 0):
		barrel.position.x *= -1
		exhaust_pipe.position.x *= -1

	#tilt the barrel to aim at the mouse
	#if angle > PI - max_barrel_angle or angle < -PI - min_barrel_angle:
	barrel.look_at(mouse_pos)

	#firing?
	if Input.is_action_just_pressed("fire") and can_fire:
		var projectile = CashWad.instance()
		get_tree().root.add_child(projectile)
		projectile.linear_velocity = velocity
		projectile.global_transform = barrel_end.global_transform
		projectile.apply_central_impulse(projectile_impulse * (barrel_end.global_position - barrel.global_position).normalized())
		projectile.money = gun_consumption * gun_efficiency
		fuel -= gun_consumption
		can_fire = false
		$BarrelCooldown.start()


func get_wealth():
	return fuel

func add_wealth(gain):
	fuel += gain

func remove_wealth(loss):
	fuel -= loss

func _on_BarrelCooldown_timeout():
	can_fire = true
