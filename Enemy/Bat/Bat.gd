extends Enemy
class_name Bat

func _ready():
    super()
    health = 50
    movement_speed = 1.7
    xp = 2.0
    GlobalClock.beat.connect(jump_towards_player)


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()
