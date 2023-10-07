extends Node

@export
var spawn_count : int

@export
var spawn_freq : int

var skeleton_scene : Resource
var pumpkin_scene : Resource
var is_upgrading := false

var rng = RandomNumberGenerator.new()

func _ready():
    skeleton_scene = preload("res://Enemy/Skeleton/Skeleton.tscn")
    pumpkin_scene = preload("res://Enemy/Pumpkin/Pumpkin.tscn")
    GlobalSignals.level_up.connect(on_level_up)
    GlobalClock.bar.connect(spawn)


func on_level_up():
    is_upgrading = true


func spawn():
    if is_upgrading:
        return

    for i in spawn_count:
        var enemy = skeleton_scene.instantiate(i)
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    print("spawned %s enemies" % spawn_count)
