extends Enemy
class_name Pumpkin

func _ready():
    super()
    health = 350
    movement_speed = 0.5
    xp = 4.0
    GlobalClock.beat.connect(jump_towards_player)


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()
