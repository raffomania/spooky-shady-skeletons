extends Enemy
class_name Pumpkin

func _ready():
    super()
    health = 200
    movement_speed = 0.5
    xp = 3.0
    GlobalClock.beat.connect(jump_towards_player)


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()
