extends Node

@export
var spawn_count : int

@export 
var spawn_freq : int 

var clock_ticks_since_last_spawn : int
var enemy_scene : Resource

var rng = RandomNumberGenerator.new()

func _ready():
    GlobalSignals.connect("global_clock_tick", spawn)
    enemy_scene = load("res://Enemy/Enemy.tscn")
    # for debugging, instantly spawn enemies
    clock_ticks_since_last_spawn = spawn_freq

func spawn():
    clock_ticks_since_last_spawn += 1
    if (clock_ticks_since_last_spawn > spawn_freq):

        for i in spawn_count:
            var enemy = enemy_scene.instantiate(i)
            var x_offset = rng.randf_range(-10.0, 10.0)
            var z_offset = rng.randf_range(-10.0, 10.0)
            enemy.position.x += x_offset
            enemy.position.z += z_offset
            add_child(enemy)
            
        print("spawned %s enemies" % spawn_count)
        clock_ticks_since_last_spawn = 0
