extends Area3D
class_name Pumpkin

# var camera : Camera3
@onready var player: Player = get_tree().get_first_node_in_group("player")

# TODO Make movement speed dependent on player speed
@export var movement_speed: float
# XP that is given to the player on death
@export var xp: float = 3.0

    #Enemy Health
var pumpkin_health_percent: float:
    set = set_health


func _ready():
    add_to_group("enemies")
    GlobalClock.beat.connect(jump)
    pumpkin_health_percent = 200.0


func jump():
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)


func _process(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity


func set_health(health: float):
    pumpkin_health_percent = health
    print_debug("take_damage", health)

    if pumpkin_health_percent <= 0:
        queue_free()

        #animation_enemy.play("die")

