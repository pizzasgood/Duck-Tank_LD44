extends Node

var last_save
var player_data
var checkpoint = PackedScene.new()

func set_checkpoint():
	last_save = OS.get_datetime()
	player_data = get_tree().get_nodes_in_group("player")[0].dump_data()
	checkpoint.pack(get_tree().get_current_scene())

func restore_checkpoint():
	if last_save:
		get_tree().change_scene_to(checkpoint)