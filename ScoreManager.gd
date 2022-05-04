extends Node

var session_started: int = 0
var session_ended: int = 0
var session_active: bool = false
var score_best: int = 0

func _ready():
	var _err: int
	_err = StateManager.connect("died", self, "session_end")
	_err = StateManager.connect("respawned", self, "session_start")
	score_best = SaveDataManager.load_best_score(0)

func get_time_current() -> float:
	return float(get_time_current_usec()) / 1000000.0

func get_time_current_usec() -> int:
	return session_ended - session_started

func get_time_best() -> float:
	return float(get_time_best_usec()) / 1000000.0

func get_time_best_usec() -> int:
	return score_best

func session_start():
	session_started = OS.get_ticks_usec()
	session_ended = session_started
	session_active = true

func session_end():
	session_ended = OS.get_ticks_usec()
	session_active = false
	print("Time: %f seconds" % get_time_current())
	update_best_score()
	if get_time_best_usec() == get_time_current_usec():
		print("(This was new best time)")
		SaveDataManager.save_best_score(get_time_best_usec())

func update_best_score():
	var score_current = get_time_current_usec()
	if score_current >= score_best:
		score_best = score_current

func _process(_dt: float):
	if session_active:
		session_ended = OS.get_ticks_usec()
		update_best_score()
