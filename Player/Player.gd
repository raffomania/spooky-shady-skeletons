extends Node3D

func _process(delta: float):
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var movement = Vector3(x, 0, z).rotated(Vector3.UP, PI / 4).normalized() * delta
	position += movement
