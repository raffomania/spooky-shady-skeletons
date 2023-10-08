extends Node

@onready
var player = $"../Player"

var difficulty : float:
    get = calc_difficulty

func calc_difficulty():
    return 1.1 ** player.xp
# func spawn_elements()

