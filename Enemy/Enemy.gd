extends StaticBody3D
class_name Enemy

# @export
# var camera : Camera3D

func _ready():
	add_to_group("enemies")
	look_at(-get_viewport().get_camera_3d().position, Vector3.RIGHT, false)
	rotate_object_local(Vector3.FORWARD, PI / 3.49)
	# rotate_x(PI / 2)

# func _process(delta):
	#turn to camera