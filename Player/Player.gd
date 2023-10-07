extends Node3D

# Speed multiplier during the dash
@export
var dash_speed_multiplier: float = 4

# Dash duration in seconds
@export
var dash_duration: float = 0.25

# Base movement speed
@export
var movement_speed: float = 2

var dashing = false
var movement = Vector3.ZERO
var current_dash_duration = 0

#Player Health
var health_percent: float:
	set = set_health

var animation_player: AnimationPlayer

func _ready():
	# trigger set_health method
	health_percent = 100.0
	$DamageDetector.area_entered.connect(attacked_by_enemy)
	animation_player = $Model/AnimationPlayer
	animation_player.get_animation("idle").loop_mode = Animation.LOOP_LINEAR

func _process(delta: float):
	if (current_dash_duration >= dash_duration):
		dashing = false
		current_dash_duration = 0

	if (dashing):
		current_dash_duration += delta
	else:
		var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		movement = Vector3(x, 0, z).rotated(Vector3.UP, PI / 4).normalized() * delta * movement_speed

		if (Input.get_action_strength("dash") and movement != Vector3.ZERO):
			movement *= dash_speed_multiplier
			dashing = true

	position += movement
	
	if (movement.length() > 0):
		$'Model'.look_at(transform.origin + movement, Vector3.UP, true) 

	# Select animation that should be playing
	if dashing:
		animation_player.play("crouch")
	elif movement != Vector3.ZERO:
		animation_player.play("sprint")
	else:
		animation_player.play("idle")


func attacked_by_enemy(other: Area3D):
	if other.is_in_group("enemies") and health_percent > 0:
		other.queue_free()
		health_percent -= 50.0
		$DamageLight.flash()
	
func set_health(health: float):
	health_percent = health
	$OmniLight3D.omni_range = health / 8.0
	if health_percent <= 0:
		animation_player.play("die")
		# stop accepting player input
		set_process(false)
