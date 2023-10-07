extends Area3D

@export
var damage : int # percent damage per attack

var timer: Timer

var movement: Vector3 = Vector3.LEFT.rotated(Vector3.UP, PI / 4)

var speed: float = 2.0

var speed_multiplier: float = 1.0

var max_speed_multiplier: float = 4.0

func _ready():
    area_entered.connect(on_area_entered)

    timer = Timer.new()
    timer.one_shot = false
    timer.timeout.connect(reverse)
    add_child(timer)
    timer.start(1.0)


func _process(delta):
    position += delta * movement * speed * speed_multiplier
    $burger.rotate_y(delta * 4)


func on_area_entered(other: Area3D):
    if other is Enemy:
        other.queue_free()	


func reverse():

    if position.distance_to(Vector3.ZERO) < 0.2:
        print("reset direction ", $"../")
        var player_movement = $"../".movement
        if (player_movement != Vector3.ZERO):
            movement = player_movement.normalized()
            speed_multiplier = min(max_speed_multiplier, speed_multiplier + 1.0)
        else:
            speed_multiplier = 1.0
    else:
        movement = movement.rotated(Vector3.UP, PI)
