extends Label

onready var tween: Tween = $Tween as Tween
var current_time: float = 0.0

func _ready():
	AutoRespawner.connect("half_second_left", self, "on_ready_to_respawn")
	StateManager.connect("died", self, "on_player_died")

func on_player_died():
	current_time = ScoreManager.get_time_current()

func on_ready_to_respawn():
	tween.interpolate_property(self, "current_time", current_time, 0.0, 0.5)
	tween.start()

func _process(_dt: float):
	if StateManager.current_state == StateManager.State.PLAYING:
		current_time = ScoreManager.get_time_current()
	self.text = TimeFormatter.format(current_time)
