extends CPUParticles2D

# When activate()ed, this particle node will detatch, run once, and then free itself

func _ready():
	emitting = false
	one_shot = true

func _reparent():
	var pos = global_position
	var new_parent = get_node("/root/main/Level")
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = pos

func activate():
	_reparent()
	$Timer.wait_time = 1.1*lifetime
	$Timer.start()
	emitting = true
	restart()

func _on_Timer_timeout():
	queue_free()
