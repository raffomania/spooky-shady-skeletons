extends Area3D

@export
var damage : float # percent damage per attack

var cake_timer: Timer


func _ready():
    area_entered.connect(on_area_entered)
    # cake timer should be dependant on global clock ticks
    cake_timer = Timer.new()
    cake_timer.one_shot = false
    cake_timer.timeout.connect(cake_time)
    add_child(cake_timer)
    cake_timer.start(4.0)

    $cake.visible = false


func _process(delta):
    $cake.rotate_y(delta * 4)
    
func take_damage(enemy: Enemy):
    enemy.enemy_health_percent -= damage
        #animation_enemy.play("age")dam
    if enemy.enemy_health_percent <= 0:
        print_debug("free")
        enemy.queue_free()

func on_area_entered(other: Area3D):
    if other is Enemy and $cake.visible:
        take_damage(other)

func cake_time():
    $cake.visible = true
    $cake.position.y = 10
    create_tween().tween_property($cake, "position", Vector3.ZERO, 0.2)
    for other in get_overlapping_areas():
        if other is Enemy:
            take_damage(other)
    await get_tree().create_timer(.5).timeout
    $cake.visible = false
