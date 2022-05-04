extends Node

enum State { MAIN_MENU, PLAYING, PAUSED, DEAD }
export var current_state = State.MAIN_MENU
signal state_changed(prev_value, new_value)

signal died
signal respawned
signal paused
signal unpaused

func set_state(new_state: int):
	if current_state != new_state:
		var prev_state = current_state
		current_state = new_state
		emit_signal("state_changed", prev_state, new_state)

		match prev_state:
			State.MAIN_MENU:
				match new_state:
					State.PLAYING:
						return emit_signal("respawned")
			State.PLAYING:
				match new_state:
					State.DEAD:
						return emit_signal("died")
					State.PAUSED:
						return emit_signal("paused")
			State.PAUSED:
				match new_state:
					State.PLAYING:
						return emit_signal("unpaused")
			State.DEAD:
				match new_state:
					State.PLAYING:
						return emit_signal("respawned")

		print_debug("Invalid state change happened: %d -> %d"
			% [prev_state, new_state])
