extends Enemy
class_name PumpkinMinion

func _ready():
    super()
    health = 150
    movement_speed = 0.5
    xp = 2.0
    GlobalClock.beat.connect(jump_towards_player)


func _process(delta):
    move_towards_player(delta)
    set_animation_shader_param()
