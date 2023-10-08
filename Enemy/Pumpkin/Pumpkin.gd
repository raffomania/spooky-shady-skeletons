extends Enemy
class_name Pumpkin

func _ready():
    super()
    health = 200
    movement_speed = 0.5
    xp = 3.0


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()