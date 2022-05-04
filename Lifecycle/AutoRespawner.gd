extends Node

export var time_to_respawn: float = 2.2

var dead: bool = false
var emitted: bool = false
var timer: float = -1.0

signal half_second_left

func _ready():
	StateManager.connect("died", self, "on_player_died")
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	dead = true
	emitted = false
	timer = time_to_respawn

func on_player_respawned():
	dead = false

func _process(dt: float):
	if dead:
		timer -= dt
		if timer <= 0.5 && not emitted:
			emit_signal("half_second_left")
			emitted = true
		if timer <= 0:
			StateManager.set_state(StateManager.State.PLAYING)
