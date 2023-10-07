extends Area3D
class_name Enemy

#movement noch vo player geschwindigkeit abhängig machen
@export var movement_speed= 10.0

# var camera : Camera3
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	var direction = global_position.direction_to(player.global_position)
	var velocity = direction * movement_speed * delta
	global_position += velocity
	
func _ready():
	add_to_group("enemies")

