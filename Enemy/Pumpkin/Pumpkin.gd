extends Enemy
class_name Pumpkin

func _ready():
    super()
    health = 200
    movement_speed = 0.5
    xp = 3.0


func _process(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity
