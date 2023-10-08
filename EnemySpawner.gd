extends Node
class_name EnemySpawner


@export var spawn_count_skeletons : int
@export var spawn_freq_skeletons : int

@export var spawn_count_pumpkins : int
@export var spawn_freq_pumpkins : int

@export var spawn_count_sheep : int
@export var spawn_freq_sheep : int

@onready var difficulty_manager = $"../DifficultyManager"

var skeleton_scene : Resource
var pumpkin_scene : Resource
var sheep_scene : Resource
var drop_scene : Resource
var is_upgrading := false

var rng = RandomNumberGenerator.new()

func _ready():
    skeleton_scene = preload("res://Enemy/Skeleton/Skeleton.tscn")
    pumpkin_scene = preload("res://Enemy/Pumpkin/Pumpkin.tscn")
    sheep_scene = preload("res://Enemy/Sheep/sheep.tscn")
    drop_scene = preload("res://Enemy/xp_orb.tscn")
    GlobalSignals.level_up.connect(on_level_up)
    GlobalSignals.new_level_chosen.connect(on_new_level_chosen)
    GlobalClock.section.connect(spawn)
    GlobalSignals.spawn_skeletons.connect(spawn_skeletons)
    GlobalClock.bar.connect(spawn)
    add_to_group("spawner")


func on_level_up():
    is_upgrading = true


func on_new_level_chosen():
    await GlobalClock.beat
    # give the player a little time to adjust
    await get_tree().create_timer(GlobalClock.beat_duration * 4).timeout
    is_upgrading = false


func spawn_skeletons(payload: Dictionary):
   for _index in range(0, payload["amount"]):
        var skeleton = skeleton_scene.instantiate()
        skeleton.position = payload['position']
        var x_offset = rng.randf_range(-2.0, 2.0)
        var z_offset = rng.randf_range(-2.0, 2.0)
        skeleton.position.x += x_offset
        skeleton.position.z += z_offset
        add_child(skeleton)
        print("skeletons spawned")


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
        var enemy = skeleton_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    for _index in spawn_count_pumpkins * difficulty:
        var enemy = pumpkin_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    for _index in spawn_count_sheep:
        var sheep = sheep_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        sheep.position.x += x_offset
        sheep.position.z += z_offset
        add_child(sheep)

    print("spawned %d pumpkins" % (spawn_count_pumpkins * difficulty))
    print("spawned %d skeletons" % (spawn_count_skeletons* difficulty))
    print("spawned %s sheep" % spawn_count_sheep)
