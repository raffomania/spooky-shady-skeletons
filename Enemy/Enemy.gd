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
    GlobalClock.beat.connect(handle_hit_animation_on_clock)

func set_animation_shader_param():
    $MeshInstance3D.get_active_material(0).set_shader_parameter("animation_progress", GlobalClock.bar_progress)

func set_sprite_direction(direction : Vector3):
    var rotated_direction_vector = direction.rotated(Vector3.UP, -PI / 4)
    var dir : int
    # rotate by Pi / 4
    if (rotated_direction_vector.z > 0):
        dir = 0
    else:
        dir = 1

    if (abs(rotated_direction_vector.x) > abs(rotated_direction_vector.z)):
        if (rotated_direction_vector.x < 0):
            dir = 2
        else:
            dir = 3

    $MeshInstance3D.get_active_material(0).set_shader_parameter("direction", dir)

func move_towards_player(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity
    set_sprite_direction(direction)


# All enemies jump based on the music beat
func jump_towards_player():
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)


var was_hit : bool
func handle_hit_animation_on_clock():
    if (was_hit):
        # now the hit sound should be played, then its in rythm
        was_hit = false
        var material = $MeshInstance3D.get_active_material(0)
        create_tween().tween_method(func(val): material.set_shader_parameter("hit_animation", val), 4.0,  0.0, GlobalClock.beat_duration / 2)


# Set the health for this enemy.
func take_damage(damage: int):
    health -= damage
    was_hit = true
    # print("Took %d damage. Health now: %d" % [damage, health])

    if health <= 0:
        # Wait until next beat to die
        await GlobalClock.beat
        spawner.drop_loot(position, xp)
        queue_free()
