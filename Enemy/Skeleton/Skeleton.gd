extends Enemy
class_name Skeleton

# XP that is given to the player on death
@export var xp: float = 1.0

func _ready():
    super()
    health = 100
    movement_speed = 0.6


func _process(delta):
    move_towards_player(delta)
