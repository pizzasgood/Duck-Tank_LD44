extends MarginContainer

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var bar = get_node("HBoxContainer/Wealth")

const log_10 = log(10)

func _ready():
	visible = true

func _process(delta):
	bar.value = player.get_wealth() / 100

