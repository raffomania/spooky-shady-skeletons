extends Node

@onready
var player = $"../Player"

var difficulty : float:
    get = calc_difficulty

func calc_difficulty():
    return 1.0001 ** player.xp
# func spawn_elements()

