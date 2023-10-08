extends Node3D

@onready
var player = $"../Player"


func _ready():
    visible = false
    GlobalSignals.level_up.connect(start_upgrading)
    for upgrade in get_children():
        upgrade.upgrade_chosen.connect(func(): upgrade_chosen(upgrade))


func upgrade_chosen(_upgrade: UpgradeChooser):
    await player.play_new_level_transition()
    visible = false
    GlobalSignals.new_level_chosen.emit()


func start_upgrading():
    visible = true
