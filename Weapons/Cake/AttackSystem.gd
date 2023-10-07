extends Area3D

@export
var damage : float # percent damage per attack

var cake_timer: Timer


func _ready():
    area_entered.connect(on_area_entered)

    GlobalClock.section.connect(cake_time)

    $cake.visible = false


func _process(delta):
    $cake.rotate_y(delta * 4)

func make_damage(enemy: Enemy):
    enemy.enemy_health_percent -= damage

func on_area_entered(other: Area3D):
    if other is Enemy and $cake.visible:
        make_damage(other)

func cake_time():
    $cake.visible = true
    $cake.position.y = 10
    create_tween().tween_property($cake, "position", Vector3.ZERO, 0.2)
    for other in get_overlapping_areas():
        if other is Enemy:
            make_damage(other)
    await get_tree().create_timer(.5).timeout
    $cake.visible = false
