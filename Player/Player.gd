extends Node3D

# Speed multiplier during the dash
@export
var dash_speed_multiplier: float = 4

# Dash duration in seconds
@export
var dash_duration: float = 0.25

# Base movement speed
@export
var movement_speed: float = 2

# dashing
var dashing = false
var movement = Vector3.ZERO
var current_dash_duration = 0
var is_dash_possible = true
var timer

#Player Health
var health_percent: float:
    set = set_health
    
# Player xp
var xp: float = 0.0
var level: int = 1

var animation_player: AnimationPlayer

func _ready():
    # trigger set_health method
    health_percent = 100.0
    $DamageDetector.area_entered.connect(attacked_by_enemy)
    animation_player = $Model/AnimationPlayer
    animation_player.get_animation("idle").loop_mode = Animation.LOOP_LINEAR
    timer = get_node("Timer")
    timer.timeout.connect(enable_dash)
    

func _process(delta: float):
    if (Input.get_action_strength("quit")):
        get_tree().quit()
    if (current_dash_duration >= dash_duration):
        dashing = false
        current_dash_duration = 0

    if (dashing):
        current_dash_duration += delta
    else:
        var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
        var z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
        movement = Vector3(x, 0, z).rotated(Vector3.UP, PI / 4).normalized() * delta * movement_speed

        if (Input.get_action_strength("dash") and movement != Vector3.ZERO and is_dash_possible):
            movement *= dash_speed_multiplier
            dashing = true
            # disables dash for 2 secs
            is_dash_possible = false
            timer.start(2)

    position += movement
    
    if (movement.length() > 0):
        $'Model'.look_at(transform.origin + movement, Vector3.UP, true) 

    # Select animation that should be playing
    if dashing:
        animation_player.play("crouch")
    elif movement != Vector3.ZERO:
        animation_player.play("sprint")
    else:
        animation_player.play("idle")


func attacked_by_enemy(other: Area3D):
    if other is Enemy and health_percent > 0 and !dashing:
        #kill_enemy(other)
        damage_enemy(other)
        health_percent -= 5.0
        $DamageLight.flash()

func damage_enemy(other: Enemy):
    if other.enemy_health_percent < 5.0:
        kill_enemy(other)
    else: 
        other.enemy_health_percent -= 5.0
        #enemy_animation("die")
        
    
    
func kill_enemy(other: Area3D):
    add_xp(other.xp)
    other.queue_free()
    
func add_xp(amount: float):
    xp += amount

    var current_level = round(log(xp))
    if current_level > level:
        level_up(current_level)

    # reset particle emitter since it is oneshot
    $XPParticles.restart()
    # scale particle amount with xp amount
    $XPParticles.amount = 10 * amount
    $XPParticles.emitting = true
    
func level_up(new_level: int):
    level = new_level
    print('level up: ', new_level)

    
func set_health(health: float):
    health_percent = health
    $HealthLight.spot_angle = 10 + 65 * (health_percent / 100.0)
    if health_percent <= 0:
        animation_player.play("die")
        # stop accepting player input
        set_process(false)

func enable_dash():
    is_dash_possible = true
    print("dash is possible now")
    
    
    
    
    
