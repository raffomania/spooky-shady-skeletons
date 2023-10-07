extends Node3D


func _ready():
    visible = false
    GlobalSignals.level_up.connect(start_upgrading)

func start_upgrading():
    visible = true
