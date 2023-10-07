extends Area3D

@onready var player: Player = get_tree().get_first_node_in_group("player")

# Enemy damage
@export var damage: int = 100

# The direction into which the burger is flying right now.
var direction: Vector3 = Vector3(1, 0, 0)
# The max distance the burger flies away from the player
const default_distance: float = 4;
const power_distance: float = 6;
var max_distance: float = 4;

func make_damage(enemy: Enemy):
    enemy.take_damage(damage)

func _ready():
    # Register our hit handler
    area_entered.connect(on_area_entered)

func _process(_delta):
    var bar_progress = GlobalClock.bar_progress
    # Rotate the burger twice each bar
    self.rotate_y(2 * bar_progress * 2 * PI)

    # Calculate the new position.
    var sin_position = bar_progress * 2 * PI
    self.position = (Vector3.LEFT * default_distance).rotated(Vector3.UP, sin_position)


func on_area_entered(other: Area3D):
    if other is Enemy:
        make_damage(other)
