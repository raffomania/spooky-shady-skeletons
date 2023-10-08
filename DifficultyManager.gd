extends Node

@onready
var player = $"../Player"

var difficulty : float:
    get = calc_difficulty

func calc_difficulty():
    return player.level
# func spawn_elements()

