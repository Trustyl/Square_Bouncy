extends AudioStreamPlayer2D

onready var tween: Tween = $Tween as Tween

func _ready():
	var _err: int
	_err = StateManager.connect("died", self, "lower_pitch")
	_err = StateManager.connect("respawned", self, "resume")
	_err = StateManager.connect("paused", self, "pause")
	_err = StateManager.connect("unpaused", self, "resume")
	_err = AutoRespawner.connect("half_second_left", self, "revert_pitch")

func lower_pitch():
	tween.stop(self)
	tween.interpolate_property(self, "pitch_scale",
		1.0, 0.5, 1.4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func revert_pitch():
	if self.pitch_scale < 1.0:
		tween.stop(self)
		tween.interpolate_property(self, "pitch_scale",
			self.pitch_scale, 1.0, 0.5,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func pause():
	self.stream_paused = true

func resume():
	if not self.playing:
		self.playing = true
	self.stream_paused = false

