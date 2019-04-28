extends CanvasLayer

var triggered = false

export var price = 1000

onready var player = get_tree().get_nodes_in_group("player")[0]

onready var offer_dialog = find_node("Offer")
onready var response_dialog = find_node("Response")
onready var response_label : Label = find_node("ResponseLabel")

onready var accept_button : Button = find_node("Pay")
onready var steal_button : Button = find_node("Steal")
onready var dismiss_button : Button = find_node("Dismiss")

onready var mechanic_spawn = get_node("/root/main").find_node("MechanicSpawn")

var Thug = load("res://entities/thug/Thug.tscn")

func _ready():
	_hide_all()

func _hide_all():
	offer_dialog.visible = false
	response_dialog.visible = false

func activate():
	if not triggered:
		triggered = true
		get_tree().paused = true
		_center_offer()
		offer_dialog.visible = true
		accept_button.grab_focus()

func _center_offer():
	offer_dialog.position = get_viewport().size / 2

func _grant_cannon():
	player.activate_cannon()

func _spawn_mechanic():
	var mechanic = Thug.instance()
	mechanic.set_bomb_cooldown(0.1)
	mechanic.bomb_random_factor = 5
	mechanic.speed *= 2
	mechanic_spawn.add_child(mechanic)

func _respond_with(message):
	response_label.text = message
	response_dialog.position = get_viewport().size / 2
	response_dialog.visible = true
	dismiss_button.grab_focus()

func _on_ShopBay_body_entered(body):
	activate()

func _on_Pay_pressed():
	offer_dialog.visible = false
	if player.get_wealth() > price:
		player.remove_wealth(price)
		_grant_cannon()
		_respond_with("Wonderful.  My children will eat tonight.  As thanks, I will not charge for the installation!")
	else:
		triggered = false
		_respond_with("Excellent.  Allow me to just... no, wait.  You don't have enough money!  You dirty cheat!  Leave, and don't come back until you have $%s." % price)

func _on_Steal_pressed():
	offer_dialog.visible = false
	_grant_cannon()
	_spawn_mechanic()
	_respond_with("You thieving rascal!  My children are starving!  ...But no longer.  Tonight... we dine on duck!  AVAST!")

func _on_Dismiss_pressed():
	_hide_all()
	get_tree().paused = false
