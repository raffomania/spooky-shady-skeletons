extends Node
class_name EnemySpawner

@export
var spawn_count_skeletons : int
@export
var spawn_count_pumpkins : int


@export
var spawn_freq_skeletons : int
@export
var spawn_freq_pumpkins : int

@onready
var difficulty_manager = $"../DifficultyManager"

var skeleton_scene : Resource
var pumpkin_scene : Resource
var drop_scene : Resource
var is_upgrading := false

var rng = RandomNumberGenerator.new()

func _ready():
    skeleton_scene = preload("res://Enemy/Skeleton/Skeleton.tscn")
    pumpkin_scene = preload("res://Enemy/Pumpkin/Pumpkin.tscn")
    drop_scene = preload("res://Enemy/xp_orb.tscn")
    GlobalSignals.level_up.connect(on_level_up)
    GlobalClock.bar.connect(spawn)
    add_to_group("spawner")


func on_level_up():
    is_upgrading = true
    
func drop_loot(position, xp):
    var drop = drop_scene.instantiate()
    drop.position = position
    drop.xp = xp
    add_child(drop)

func spawn():
    if is_upgrading:
        return

    var difficulty = difficulty_manager.difficulty
    for i in spawn_count_skeletons * difficulty:
        var enemy = skeleton_scene.instantiate(i)
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)
        
    for i in spawn_count_pumpkins * difficulty:
        var enemy = pumpkin_scene.instantiate(i)
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    print("spawned %d pumpkins" % (spawn_count_pumpkins * difficulty))
    print("spawned %d skeletons" % (spawn_count_skeletons* difficulty))
    # print("spawned %s pumpkins" % spawn_count_pumpkins)
