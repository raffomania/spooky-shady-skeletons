extends Friendly
class_name Sheep

@onready var start_position = global_position
@onready var target_position = global_position


func jump_towards_target():
    var direction = global_position.direction_to(update_target_position())
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)


func _ready():
    super()
    health = 60
    movement_speed = 0.8
    xp = 1
    GlobalClock.beat.connect(jump_towards_target)


func update_target_position():
    var target_vector = Vector3(randf_range(-32, 32),0, randf_range(-32, 32))
    target_position = start_position + target_vector
    return target_position


func is_at_target_position():
    # Stop moving when at target +/- tolerance
    const TOLERANCE = 4.0
    return (target_position - global_position).length() < TOLERANCE


func take_damage(damage: int):
    health -= damage
    was_hit = true

    if health <= 0:
        print("sheep died")
        spawner.drop_loot(position, xp)
        GlobalSignals.spawn_skeletons.emit({
            "amount": 4,
            "position":global_position,
        })
        queue_free()


func _process(delta):
    var direction = global_position.direction_to(update_target_position())
    var velocity = direction * movement_speed * delta
    global_position += velocity
    if is_at_target_position():
        update_target_position()
