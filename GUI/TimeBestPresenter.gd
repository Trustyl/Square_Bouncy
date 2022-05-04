extends Label

func _process(_dt: float):
	var time_seconds = ScoreManager.get_time_best()
	self.text = TimeFormatter.format(time_seconds)
