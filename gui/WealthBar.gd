extends MarginContainer

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var bar = find_node("Wealth")
onready var total = find_node("Total")

const log_10 = log(10)

func _ready():
	visible = true

func _process(delta):
	bar.value = player.get_wealth() / 100
	total.text = "$%s" % round(player.get_wealth())
