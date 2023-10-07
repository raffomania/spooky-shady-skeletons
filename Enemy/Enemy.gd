extends CharacterBody3D
class_name Enemy
#movement noch vo player geschwindigkeit abhängig machen
@export var movement_speed= 10.0

# var camera : Camera3
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	move_and_slide()
	
func _ready():
	add_to_group("enemies")
	look_at(-get_viewport().get_camera_3d().position, Vector3.RIGHT, false)
	rotate_object_local(Vector3.FORWARD, PI / 3.49)
	# rotate_x(PI / 2)

# func _process(delta):
	#turn to camera
	
	
