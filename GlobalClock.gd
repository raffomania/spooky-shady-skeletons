extends Node

@export
# spooky scary skeletons has 154 (maybe 155) bpm
var beats_per_minute : int

var seconds_between_clock_ticks: float
var seconds_since_last_clock_tick : float

func clock_tick():
    GlobalSignals.emit_signal("global_clock_tick")


func _ready():
    seconds_between_clock_ticks = 60.0 / beats_per_minute


func _process(delta):
    seconds_since_last_clock_tick += delta

    if (seconds_since_last_clock_tick >= seconds_between_clock_ticks):
        clock_tick()
        seconds_since_last_clock_tick = 0

