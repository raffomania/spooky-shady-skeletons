extends Area3D
class_name UpgradeChooser

signal upgrade_chosen

@export
var kind: Upgrade.Kind:
    set = set_kind

func _ready():
    $CountdownLabel.countdown_finished.connect(func(): upgrade_chosen.emit(kind))


func set_kind(val: Upgrade.Kind):
    kind = val
    $Description.text = Upgrade.description(kind)


func start_countdown():
    $CountdownLabel.show_countdown()


func stop_countdown():
    $CountdownLabel.stop_countdown()
