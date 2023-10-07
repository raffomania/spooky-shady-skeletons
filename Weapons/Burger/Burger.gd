extends Area3D

@onready var player: Player = get_tree().get_first_node_in_group("player")

# Enemy damage in percent
@export var damage: float

# The burger does one back and forth every music bar.
# This value resets via a signal every time a bar finishes.
var time_since_last_bar: float = 0.0
# The direction into which the burger is flying right now.
var direction: Vector3 = Vector3(1, 0, 0)
# The max distance the burger flies away from the player
var max_distance: float = 4;

func make_damage(enemy: Enemy):
	enemy.enemy_health_percent -= damage

func _ready():
	# Register on the global clock
	# We want the burger to move in the beat of the music
	# We use use the bar to reset the timer to prevent drift.
	GlobalClock.connect("bar", bar_finished)

	# Register our hit handler
	area_entered.connect(on_area_entered)

func _process(delta):
	# Increase the timer
	time_since_last_bar += delta

	# Determine how far we're in the current bar
	var bar_progress = time_since_last_bar / (GlobalClock.beat_duration * 4)

	# Rotate the burger twice each bar
	self.rotate_y(2 * bar_progress * 2 * PI)

	# Calculate the new position.
	# The speed of the burger follows half of a sin cycle
	# It get's faster, reaches a "velocity" of 0 at the max distance
	# and comes back.
	var sin_position = sin(bar_progress * PI)
	print("Bar progress %f, sin_position: %f" % [bar_progress, sin_position])
	self.position = direction.normalized() * sin_position * max_distance
	print("Position Vector: %f, %f, %f" % [self.position.x, self.position.y, self.position.z])


func on_area_entered(other: Area3D):
	if other is Enemy:
		make_damage(other)


# The Burger is now back on top of the player
func bar_finished():
	# Reset the timer to keep the timer in sync
	time_since_last_bar = 0.0

	# We have a game mechanic that allows the player to     u       h
 #   if player.movement_direction.x > 0 && self.direction.x > 0:

	# By default, reverse the direction
	direction = direction * -1
