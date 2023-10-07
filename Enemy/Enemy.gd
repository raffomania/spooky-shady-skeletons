extends Area3D
class_name Enemy

# var camera : Camera3
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var spawner = get_tree().get_first_node_in_group("spawner")
var movement_speed: float

# XP that is given to the player on death
@export var xp: float = 1.0

# Enemy Health
# Also define a setter for the health property
var health: int


# Register all enemies to the enemies group
# Also connect to the GlobalClock for beat based animations
func _ready():
    add_to_group("enemies")
    GlobalClock.beat.connect(jump)

func move_towards_player(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity


# All enemies jump based on the music beat
func jump():
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)


# Set the health for this enemy.
func take_damage(damage: int):
    health -= damage
    #print("Took %d damage. Health now: %d" % [damage, health])

    if health <= 0:
        spawner.drop_loot(position, xp)
        queue_free()

        #animation_enemy.play("die")
