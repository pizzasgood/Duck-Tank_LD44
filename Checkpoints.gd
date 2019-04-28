extends Node

var music = true

var last_save
var station
var player_data
var checkpoint = PackedScene.new()

func set_checkpoint(use_station = null):
	last_save = OS.get_datetime()
	station = use_station
	player_data = get_tree().get_nodes_in_group("player")[0].dump_data()
	checkpoint.pack(get_tree().get_current_scene())

func restore_checkpoint():
	if last_save:
		get_tree().change_scene_to(checkpoint)

func clear():
	last_save = null
	station = null
	player_data = null

func available():
	return last_save != null