extends Area3D
class_name UpgradeChooser

signal upgrade_chosen

@export
var kind: Upgrade.Kind

func _ready():
    $CountdownLabel.countdown_finished.connect(func(): upgrade_chosen.emit())
    $Description.text = Upgrade.description(kind)


func start_countdown():
    $CountdownLabel.show_countdown()


func stop_countdown():
    $CountdownLabel.stop_countdown()
