extends Area3D
class_name UpgradeChooser

signal upgrade_chosen

@export
var kind: Upgrade.Kind

func _ready():
    $Label3D.countdown_finished.connect(func(): upgrade_chosen.emit())


func start_countdown():
    $Label3D.show_countdown()


func stop_countdown():
    $Label3D.stop_countdown()
