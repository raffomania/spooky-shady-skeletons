extends Enemy
class_name Skeleton

func _ready():
    super()
    health = 100
    movement_speed = 0.6
    GlobalClock.beat.connect(jump_towards_player)


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()
