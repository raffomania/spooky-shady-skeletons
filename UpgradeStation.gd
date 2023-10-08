extends Node3D

@onready
var player = $"../Player"

var enabled_upgrades: Array[Upgrade.Kind] = []


func _ready():
    visible = false
    GlobalSignals.level_up.connect(start_upgrading)
    set_choosable_upgrades()

    for chooser in get_children():
        chooser.upgrade_chosen.connect(upgrade_chosen)

func set_choosable_upgrades():
    var available = Upgrade.Kind.values().filter(func(kind): return Upgrade.can_get_upgrade(enabled_upgrades, kind))

    available.shuffle()
    for chooser in get_children():
        var kind = available.pop_back()
        if kind != null:
            chooser.visible = true
            chooser.kind = kind
        else:
            chooser.visible = false


func upgrade_chosen(upgrade: Upgrade.Kind):
    await player.play_new_level_transition()
    visible = false
    enabled_upgrades.push_back(upgrade)
    GlobalSignals.new_level_chosen.emit(upgrade)
    set_choosable_upgrades()


func start_upgrading(_level: int):
    visible = true
