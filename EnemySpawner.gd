extends Node
class_name EnemySpawner


@export var spawn_count_skeletons : int
@export var spawn_freq_skeletons : int

@export var spawn_count_pumpkin_minions : int
@export var spawn_freq_pumpkin_minions : int

@export var spawn_count_pumpkins : int
@export var spawn_freq_pumpkins : int

@export var spawn_count_bat : int
@export var spawn_freq_bat : int

@export var spawn_count_sheep : int
@export var spawn_freq_sheep : int

@onready var difficulty_manager = $"../DifficultyManager"

var skeleton_scene : Resource
var pumpkin_scene : Resource
var pumpkin_minion_scene : Resource
var sheep_scene : Resource
var bat_scene : Resource
var drop_scene : Resource
var is_upgrading := false

var rng = RandomNumberGenerator.new()

func _ready():
    skeleton_scene = preload("res://Enemy/Skeleton/Skeleton.tscn")
    pumpkin_scene = preload("res://Enemy/Pumpkin/Pumpkin.tscn")
    pumpkin_minion_scene = preload("res://Enemy/PumpkinMinion/PumpkinMinion.tscn")
    sheep_scene = preload("res://Enemy/Sheep/sheep.tscn")
    bat_scene = preload("res://Enemy/Bat/Bat.tscn")
    drop_scene = preload("res://Enemy/xp_orb.tscn")
    GlobalSignals.level_up.connect(on_level_up)
    GlobalSignals.new_level_chosen.connect(on_new_level_chosen)
    GlobalClock.section.connect(spawn)
    GlobalSignals.spawn_skeletons.connect(spawn_skeletons)
    add_to_group("spawner")


func on_level_up(level: int):
    is_upgrading = true
    for child in get_children():
        if child.has_method("take_damage") and child.get("health") != null:
            child.take_damage(child.health)
        else:
            child.queue_free()

    # Increase enemy spawn amount
    spawn_count_skeletons += 1

    if (level % 2 == 0):
        spawn_count_pumpkin_minions += 1
    if (level % 3 == 0):
        spawn_count_sheep += 1
        spawn_count_bat += 1
    if (level % 4 == 0):
        spawn_count_pumpkins += 1


func on_new_level_chosen(_upgrade: Upgrade.Kind):
    await GlobalClock.beat
    # give the player a little time to adjust
    await get_tree().create_timer(GlobalClock.beat_duration * 2).timeout
    is_upgrading = false


func spawn_skeletons(payload: Dictionary):
    if is_upgrading: return
    for _index in range(0, payload["amount"]):
        var skeleton = skeleton_scene.instantiate()
        skeleton.position = payload['position']
        var x_offset = rng.randf_range(-2.0, 2.0)
        var z_offset = rng.randf_range(-2.0, 2.0)
        skeleton.position.x += x_offset
        skeleton.position.z += z_offset
        add_child(skeleton)


func drop_loot(position, xp):
    if is_upgrading: return
    var drop = drop_scene.instantiate()
    drop.position = position
    drop.xp = xp
    add_child(drop)


func spawn():
    if is_upgrading or GlobalClock.beats < 4:
        return

    for i in spawn_count_skeletons:
        var enemy = skeleton_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    for _index in spawn_count_pumpkins:
        var enemy = pumpkin_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        enemy.position.x += x_offset
        enemy.position.z += z_offset
        add_child(enemy)

    for _index in spawn_count_pumpkin_minions:
        var enemy = pumpkin_minion_scene.instantiate()
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

    for _index in spawn_count_bat:
        var bat = bat_scene.instantiate()
        var x_offset = rng.randf_range(-10.0, 10.0)
        var z_offset = rng.randf_range(-10.0, 10.0)
        bat.position.x += x_offset
        bat.position.z += z_offset
        add_child(bat)

    print("spawned %d pumpkin minions" % spawn_count_pumpkin_minions)
    print("spawned %d pumpkins" % spawn_count_pumpkins)
    print("spawned %d skeletons" % spawn_count_skeletons)
    print("spawned %s sheep" % spawn_count_sheep)
    print("spawned %s bat" % spawn_count_bat)
