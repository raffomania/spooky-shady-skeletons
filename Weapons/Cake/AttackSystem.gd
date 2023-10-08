extends Area3D

# Damage per attack
@export var damage: int

var cake_timer: Timer


func _ready():
    GlobalClock.section.connect(cake_time)

    $cake.visible = false


func _process(delta):
    $cake.rotate_y(delta * 4)

func make_damage(enemy: Enemy):
    enemy.take_damage(damage)

func cake_time():
    $cake.visible = true
    $cake.position.y = 10
    create_tween().tween_property($cake, "position", Vector3.ZERO, 0.2)
    for other in get_overlapping_areas():
        if other is Enemy:
            make_damage(other)
    await get_tree().create_timer(.5).timeout
    $cake.visible = false
