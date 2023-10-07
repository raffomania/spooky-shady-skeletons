extends Area3D
class_name Enemy

#movement noch vo player geschwindigkeit abhängig machen
@export var movement_speed: float

# var camera : Camera3
@onready var player = get_tree().get_first_node_in_group("player")

# XP that is given to the player on death
@export
var xp: float = 1.0

    #Enemy Health
var enemy_health_percent: float:
    set = set_health


func _ready():
    add_to_group("enemies")
    GlobalClock.beat.connect(jump)
    enemy_health_percent = 100.0


func jump():
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)
    
func _process(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity

    
func set_health(health: float):
    enemy_health_percent = health
    print_debug("take_damage", health)

    if enemy_health_percent <= 0:
        queue_free()
        
        #animation_enemy.play("die")
        
