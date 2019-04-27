extends MarginContainer

onready var player = get_node("/root/main/Player")
onready var bar = get_node("HBoxContainer/Wealth")

const log_10 = log(10)

func _process(delta):
	bar.value = player.get_wealth() / 100
