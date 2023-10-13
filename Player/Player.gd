extends Node3D
class_name Player

# Speed multiplier during the dash
@export var dash_speed_multiplier: float = 4
# Dash duration in seconds
@export var dash_duration: float = 0.25
# Base movement speed
@export var movement_speed: float = 2

var dashing: bool = false
var movement: Vector3 = Vector3.ZERO
var movement_direction: Vector3 = Vector3(0, 0, 0)
var current_dash_duration: float = 0
var is_dash_possible: bool = true
var timer_dash
var dash_cooldown := 1.5

#Player Health
var health_percent: float:
    set = set_health

@onready
var health_light_default_energy = $HealthLight.light_energy

# Player xp
var xp: float = 1.0
var level: int = 1

func _ready():
    # trigger set_health method
    health_percent = 100.0
    $DamageDetector.area_entered.connect(attacked_by_enemy)
    $DamageDetector.area_entered.connect(enter_upgrade)
    $DamageDetector.area_exited.connect(exit_upgrade)
    $DamageDetector.area_entered.connect(collect_xp_orb)
    GlobalSignals.new_level_chosen.connect(on_upgrade_chosen)
    timer_dash = get_node("Timer")
    timer_dash.timeout.connect(enable_dash)


func _process(delta: float):
    set_animation_shader_param()

    if (Input.get_action_strength("quit")):
        get_tree().quit()
    if (Input.get_action_strength("level_up")):
        GlobalSignals.level_up.emit(level)
    if (current_dash_duration >= dash_duration):
        dashing = false
        current_dash_duration = 0

    if (dashing):
        current_dash_duration += delta
    else:
        var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
        var z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
        if x != 0 || z != 0:
            # Save the movement direction, since this is important for some weapons.
            movement_direction = Vector3(x, 0, z).rotated(Vector3.UP, PI / 4).normalized()
            movement = movement_direction * delta * movement_speed
        else:
            # Save the movement direction, since this is important for some weapons.
            movement_direction = Vector3(0, 0, 0)
            movement = movement_direction

        if (Input.get_action_strength("dash") and movement != Vector3.ZERO and is_dash_possible):
            movement *= dash_speed_multiplier
            dashing = true
            # disables dash for 2 secs
            is_dash_possible = false
            timer_dash.start(dash_cooldown)
            $DashParticles.rotation = movement * -1
            $DashParticles.restart()

    set_sprite_direction(movement_direction)

    position += movement

func attacked_by_enemy(other: Area3D):
    if other is Enemy and health_percent > 0 and !dashing:
        kill_enemy(other)
        health_percent -= 5.0
        $DamageLight.flash()

func kill_enemy(other: Area3D):
    add_xp(other.xp)
    other.queue_free()

func add_xp(amount: float):
    xp += amount

    var current_level = floor(log(xp) / log(2))
    if current_level > level:
        level_up(current_level)

    # reset particle emitter since it is oneshot
    $XPParticles.restart()
    # scale particle amount with xp amount
    $XPParticles.amount = 10 * amount
    $XPParticles.emitting = true

func level_up(new_level: int):
    level = new_level
    # reset health on level up
    health_percent = min(health_percent + 20, 100)
    GlobalSignals.level_up.emit(level)
    print('level up: ', new_level)

func set_health(health: float):
    health_percent = health
    $HealthLight.spot_angle = 10 + 65 * (health_percent / 100.0)
    if health_percent <= 0:
        # stop accepting player input
        set_process(false)

func enable_dash():
    is_dash_possible = true

func enter_upgrade(other: Area3D):
    if other is UpgradeChooser and health_percent > 0:
        other.start_countdown()


func exit_upgrade(other: Area3D):
    if other is UpgradeChooser:
        other.stop_countdown()


func play_new_level_transition():
    await GlobalClock.beat
    var tween = create_tween()
    tween.tween_property($HealthLight, "light_energy", 0.0, GlobalClock.beat_duration * 4)
    await tween.finished
    # animation has finished, let the dark stay
    # for a little while
    await GlobalClock.bar


func on_upgrade_chosen(upgrade: Upgrade.Kind):
    create_tween().tween_property($HealthLight, "light_energy",  health_light_default_energy, GlobalClock.beat_duration * 2)

    match upgrade:
        Upgrade.Kind.Cake:
            var cake = preload("res://Weapons/Cake/cake_weapon.tscn").instantiate()
            add_child(cake)
        Upgrade.Kind.Speed:
            movement_speed *= 1.1
        Upgrade.Kind.DashCooldown:
            dash_cooldown *= 0.75
        Upgrade.Kind.Donut:
            var donut = preload("res://Weapons/Donut/Donut.tscn").instantiate()
            add_child(donut)
        Upgrade.Kind.BurgerDamage:
            $'Burger'.damage = floor($'Burger'.damage * 2)



func collect_xp_orb(other: Area3D):
    if other is XPOrb and health_percent > 0:
        other.collected = true
        add_xp(other.xp)
        other.queue_free()


func set_animation_shader_param():
    $Billboard.get_active_material(0).set_shader_parameter("animation_progress", GlobalClock.beat_progress)
    $ShadowPlane.get_active_material(0).set_shader_parameter("animation_progress", GlobalClock.beat_progress)
    $ShadowPlane.get_active_material(0).set_shader_parameter("light_position", $HealthLight.global_position + Vector3(0.2, 0, 0.01))

func set_sprite_direction(direction : Vector3):
    var rotated_direction_vector = direction.rotated(Vector3.UP, -PI / 4)
    var dir : int
    # rotate by Pi / 4
    if (rotated_direction_vector.z > 0):
        dir = 0
    else:
        dir = 1

    if (abs(rotated_direction_vector.x) > abs(rotated_direction_vector.z)):
        if (rotated_direction_vector.x < 0):
            dir = 2
        else:
            dir = 3
            
    if (direction.length() < 0.00001):
        dir = 0
        $Billboard.get_active_material(0).set_shader_parameter("idle", true)
    else:
        $Billboard.get_active_material(0).set_shader_parameter("idle", false)

    $Billboard.get_active_material(0).set_shader_parameter("direction", dir)

