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
    GlobalClock.beat.connect(handle_hit_animation_on_clock)

func set_animation_shader_param():
    $MeshInstance3D.get_active_material(0).set_shader_parameter("animation_progress", GlobalClock.bar_progress)

func move_towards_player(delta):
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed * delta
    global_position += velocity

# All enemies jump based on the music beat
func jump():
    var direction = global_position.direction_to(player.global_position)
    var velocity = direction * movement_speed
    create_tween().tween_property(self, "position", position + velocity, 0.1)

var was_hit : bool
var shows_hit_animation : bool
func handle_hit_animation_on_clock(): 
    # exeuted every_beat
    if (shows_hit_animation):
        shows_hit_animation = false
        $MeshInstance3D.get_active_material(0).set_shader_parameter("hit_animation", 0.0)
        print_debug("hit off")

    if (was_hit):
        print_debug("was hit")
        # now the hit sound should be played, then its in rythm
        was_hit = false
        shows_hit_animation=true

func handle_hit_animation_on_process():
    if (shows_hit_animation):
        $MeshInstance3D.get_active_material(0).set_shader_parameter("hit_animation", sin(GlobalClock.beat_progress) * 2)

# Set the health for this enemy.
func take_damage(damage: int):
    health -= damage
    was_hit = true
    # print("Took %d damage. Health now: %d" % [damage, health])

    if health <= 0:
        spawner.drop_loot(position, xp)
        queue_free()

        #animation_enemy.play("die")
