extends Sprite

onready var tween: Tween = $Tween as Tween

func tick_color_preserve_alpha(color: Color, duration: float):
	tween.stop(self)
	tween.seek(tween.get_runtime())
	var current_color: Color = self.self_modulate
	color.a = current_color.a
	self.self_modulate = color
	move_to_color(current_color, duration)

func move_to_color(color: Color, duration: float):
	tween.stop(self)
	if duration == 0.0:
		self.self_modulate = color
	else:
		tween.interpolate_property(self, "self_modulate",
			self.self_modulate, color, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
