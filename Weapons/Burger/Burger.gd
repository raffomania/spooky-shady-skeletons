extends Area3D

@onready var player: Player = get_tree().get_first_node_in_group("player")

# Enemy damage in percent
@export var damage: float

# The direction into which the burger is flying right now.
var direction: Vector3 = Vector3(1, 0, 0)
# The max distance the burger flies away from the player
const default_distance: float = 4;
const power_distance: float = 6;
var max_distance: float = 4;

func make_damage(enemy: Enemy):
    enemy.enemy_health_percent -= damage

func _ready():
    # Register on the global clock
    # We want the burger to move in the beat of the music
    # We use use the bar to reset the timer to prevent drift.
    GlobalClock.connect("bar", bar_finished)

    # Register our hit handler
    area_entered.connect(on_area_entered)

func _process(_delta):
    var bar_progress = GlobalClock.bar_progress
    # Rotate the burger twice each bar
    self.rotate_y(2 * bar_progress * 2 * PI)

    # Calculate the new position.
    # The speed of the burger follows half of a sin cycle
    # It get's faster, reaches a "velocity" of 0 at the max distance
    # and comes back.
    var sin_position = sin(bar_progress * PI)
    self.position = direction.normalized() * sin_position * max_distance


func on_area_entered(other: Area3D):
    if other is Enemy:
        make_damage(other)


# The Burger is now back on top of the player
func bar_finished():
    # Reset the max distance to the default
    max_distance = default_distance

    # We have a game mechanic that allows the player to adjust the burger direction
    # if the player runs in the oposite left/right direction the burger is coming from.
    # I.e if the burger comes back from the right side (flies to the left) and the player
    # currently moves right (right-up/right/right-down), the burger changes to the player movement direction.
    #
    # Also, if the player
    #
    # However, the "left/right" is not the left right from the grid, but rather the 45degree rotated view from the camera.
    # To be able to have a simple "left/right" comparison, we have to rotate both vectors back to align to them to the grid.
    var player_direction = player.movement_direction.rotated(Vector3.UP, -PI / 4)
    var burger_direction = self.direction.rotated(Vector3.UP, -PI / 4)

    if player_direction.is_zero_approx():
        # If the player is not moving, reverse the direction
        direction = direction * -1
    elif burger_direction.angle_to(player_direction) < 0.2:
        # Give the burger a boost, if the player looks at nearly the exact opposite direction of the burger
        direction = player.movement_direction.normalized()
        max_distance = power_distance
    elif burger_direction.x > 0 && player_direction.x > 0 || burger_direction.x < 0 && player_direction.x < 0:
        # Change direction, if the player shows in the opposite x direction as the burger.
        direction = player.movement_direction.normalized()
    else:
        # By default, reverse the direction
        direction = direction * -1
