extends Node3D

# Speed multiplier during the dash
@export
var dash_speed_multiplier: float = 4

# Dash duration in seconds
@export
var dash_duration: float = 0.5

var dashing = false
var movement = Vector3.ZERO
var current_dash_duration = 0

#Player Health
var health_percent = 100

func _process(delta: float):
	if (current_dash_duration >= dash_duration):
		dashing = false
		current_dash_duration = 0

	if (dashing):
		current_dash_duration += delta
	else:
		var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		movement = Vector3(x, 0, z).rotated(Vector3.UP, PI / 4).normalized() * delta

		if (Input.get_action_strength("dash") and movement != Vector3.ZERO):
			movement *= dash_speed_multiplier
			dashing = true

	position += movement
	
	if (movement.length() > 0):
		$'Model'.look_at(transform.origin + movement, Vector3.UP, true) 

	
func set_health(health: int):
	health_percent = health
	$OmniLight3D.omni_range = health / 10.0
	
	
	
