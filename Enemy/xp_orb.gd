extends Area3D

var wobble_height = 0.01
var offset = Vector3.UP * wobble_height

@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var xp: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
    position += (offset * 10)

    # Register our hit handler
    area_entered.connect(on_area_entered)

func on_area_entered(other: Node3D):
    if other is Player:
        player.add_xp(xp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    var bar_progress = GlobalClock.bar_progress
    var sin_position = sin(bar_progress * 2 * PI)
    position += offset * sin_position
