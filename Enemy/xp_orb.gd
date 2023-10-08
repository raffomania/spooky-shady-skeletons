extends Area3D
class_name XPOrb

var wobble_height = 0.01
var offset = Vector3.UP * wobble_height

@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var xp: float = 1.0

var collected := false

# Called when the node enters the scene tree for the first time.
func _ready():
    position += (offset * 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var bar_progress = GlobalClock.bar_progress
    var sin_position = sin(bar_progress * 2 * PI)
    position += offset * sin_position * delta

    # move towards player
    if collected:
        global_position += (player.global_position - global_position) * delta * 5
