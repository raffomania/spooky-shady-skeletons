extends Enemy
class_name Pumpkin

# XP that is given to the player on death
@export var xp: float = 3.0

func _ready():
    super()
    health = 200
    movement_speed = 0.5


func _process(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity
