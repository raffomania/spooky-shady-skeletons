extends Node

# Spooky song has 127 bpm
var beats_per_minute := 127
var beat_duration := 60.0 / beats_per_minute

# beats are the base rhythm unit, each time
# the kickdrum hits it's a beat
# also known as a quarter note
signal beat
# a bar is 4 beats
signal bar
# a section is 16 beats
signal section

var beats: int

var time_begin
var time_delay
var next_beat_time : float
var previous_beat_time: float
var previous_bar_time: float

# From 0 to 1, indicates how far along we are until
# the next beat arrives.
# 0: a beat just happened
# 0.5: halfway between beats
# 0.99: a beat is about to happen
# 1: Beat is now
var beat_progress

# From 0 to 1, indicates how far along we are until
# the next bar arrives.
# 0: a 4/4 bar just finished
# 0.75: 3 bars in
# 0.99: a beat is about to happen
# 1: A 4/4 bar is done and a new one starts
var bar_progress

func _ready():
    # get_tree().get_root().get_node("/root/Main/AudioStreamPlayer").finished.connect(start_playing)
    start_playing()

func start_playing():
    beats = 0
    next_beat_time = 0.0
    previous_beat_time = 0.0
    previous_bar_time = 0.0
    time_begin = Time.get_ticks_usec()
    # time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
    time_delay = 0
    # get_tree().get_root().get_node("/root/Main/AudioStreamPlayer").play()


func _process(_delta):
    # Obtain from ticks.
    var time = (Time.get_ticks_usec() - time_begin) / 1_000_000.0
    # Compensate for latency.
    time -= time_delay
    # May be below 0 (did not begin yet).
    time = max(0, time)

    beat_progress = (time - previous_beat_time) / beat_duration
    bar_progress = (time - previous_bar_time) / (beat_duration * 4)

    if time >= next_beat_time:
        emit_beat()


func emit_beat():
    beat.emit()
    previous_beat_time = next_beat_time
    # print("beat %d" % beats)
    if beats % 4 == 0:
        bar.emit()
        # print("bar ", floor(float(beats) / 4))
        previous_bar_time = next_beat_time
    if beats % 16 == 0:
        section.emit()

    # compute stuff for next beat
    beats += 1
    next_beat_time = beats * beat_duration
