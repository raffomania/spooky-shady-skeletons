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

var anim_offset : float

# Register all enemies to the enemies group
# Also connect to the GlobalClock for beat based animations
func _ready():
    add_to_group("enemies")
    # randomize animation
    # anim_offset = (randi() % 4) * GlobalClock.beat_duration

func set_animation_shader_param():
    var anim_with_offset = GlobalClock.bar_progress # + anim_offset

    if anim_with_offset > 1:
        anim_with_offset -= 1

    $MeshInstance3D.get_active_material(0).set_shader_parameter("animation_progress", anim_with_offset)

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
    if health <= 0: return

    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity
    set_sprite_direction(direction)


# All enemies jump based on the music beat
func jump_towards_player():
    if health <= 0: return

    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)


# Set the health for this enemy.
func take_damage(damage: int):
    health -= damage
    # print("Took %d damage. Health now: %d" % [damage, health])

    var material = $MeshInstance3D.get_active_material(0)
    create_tween().tween_method(func(val): material.set_shader_parameter("hit_animation", val), 4.0,  0.0, GlobalClock.beat_duration / 2)

    if health <= 0:
        # Wait until next beat to die
        spawner.drop_loot(position, xp)
        var tween = create_tween()
        tween.tween_property(self, "position", position + Vector3.DOWN * 8, GlobalClock.beat_duration * 2)
        await tween.finished
        queue_free()
