extends Node2D

onready var vault = find_node("Vault")

func _ready():
	pass

func _count_enemies_in_vault():
	var total = 0
	for child in vault.get_children():
		if child.is_in_group("enemies"):
			total += 1
	return total

func _check_victory_condition():
	if _count_enemies_in_vault() == 0:
		return true
	return false

func _process(delta):
	if _check_victory_condition():
		get_tree().get_current_scene().find_node("Victory").activate()