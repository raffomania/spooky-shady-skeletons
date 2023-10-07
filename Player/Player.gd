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
var health_percent: float:
	set = set_health

func _ready():
	# trigger set_health method
	health_percent = 100.0
	$DamageDetector.area_entered.connect(attacked_by_enemy)

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

func attacked_by_enemy(other: Area3D):
	if other.is_in_group("enemies"):
		other.queue_free()
		health_percent -= 5.0
	
func set_health(health: float):
	health_percent = health
	$OmniLight3D.omni_range = health / 8.0
