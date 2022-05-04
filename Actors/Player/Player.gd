extends Node2D

onready var tween: Tween = $Tween as Tween

## How easy it is for the player to change horizontal velocity?
export var friction_x: float = 4000.0

## How fast can the player move horizontally?
export var speed_x: float = 500.0

## How fast does the player bounce vertically?
export var speed_y: float = 425.0

var velocity_x: float = 0.0
var velocity_y: float = speed_y

signal went_too_high
signal went_too_low

func _process(dt: float):

	var state = StateManager.current_state
	if state == StateManager.State.PAUSED || state == StateManager.State.DEAD:
		return

	if state == StateManager.State.PLAYING:

		# Calculate a target velocity by reading the player inputs
		var target_velocity_x: float = 0.0
		target_velocity_x += Input.get_action_strength("player_right")
		target_velocity_x -= Input.get_action_strength("player_left")
		target_velocity_x *= speed_x

		# Move the actual velocity towards the target
		var max_step: float = friction_x * dt
		var diff_x: float = target_velocity_x - velocity_x
		if abs(diff_x) < max_step:
			velocity_x = target_velocity_x
		else:
			velocity_x += max_step * sign(diff_x)

	# Apply calculated velocity
	position += Vector2(velocity_x, velocity_y) * dt

	# If the player is vertically out of bounds,
	# reverse their vertical velocity
	if position.y > Arena.y_max:
		emit_signal("went_too_low")
		velocity_y *= sign(velocity_y) * -1.0
		var difference = position.y - Arena.y_max
		if abs(difference) > Arena.height:
			position.y = Arena.y_max
		else:
			position.y -= difference
	elif position.y < Arena.y_min:
		emit_signal("went_too_high")
		velocity_y *= sign(velocity_y)
		var difference = Arena.y_min - position.y
		if abs(difference) > Arena.height:
			position.y = Arena.y_min
		else:
			position.y += difference

	# If the player is horizontally out of bounds, just wrap them
	if position.x > Arena.x_max:
		position.x -= Arena.width
	elif position.x < Arena.x_min:
		position.x += Arena.width


func on_collider_enter(_rid: int, other: Area2D,
					   _other_idx: int, _this_idx: int,
					   trigger_name: String):

	# The left and right player clones also are colliders
	# in order for the player to watch out for the screen edges.
	# However, we do not want to kill the player
	# when the collision happens *outside* the screen.
	var trigger = get_node(trigger_name) as Area2D
	var pos_x = trigger.position.x + position.x
	if abs(pos_x) > (360.0 + 16.0) || abs(other.position.x) > (360.0 + 24.0 - 10.0):
		return

	# The collision was visible on the screen.
	# If the player is alive, kill them
	if StateManager.current_state == StateManager.State.PLAYING:
		StateManager.set_state(StateManager.State.DEAD)
		other.set_deferred("monitorable", false)
		tween.interpolate_property(other, "modulate", other.modulate, Color.red, 1.0)
		tween.start()
