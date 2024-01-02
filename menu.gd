extends Control

func _ready():
    $NewRun.pressed.connect(new_run)

func new_run():
    get_tree().change_scene_to_file("res://main.tscn")
