extends Node2D

onready var viewport: Viewport = get_viewport()
onready var sprite: Sprite = $Background as Sprite

func _ready():
	var _err = viewport.connect("size_changed", self, "adjust_scale")
	adjust_scale()

## Rescales this element, so that the child sprite
## can fill the entire screen, keeping the aspect ratio
func adjust_scale():
	var window_size: Vector2 = OS.window_size
	var self_size: Vector2 = sprite.texture.get_size()
	var self_ratio: float = self_size.x / self_size.y
	var screen_ratio: float = window_size.x / window_size.y
	var target_ratio = min(self_ratio, screen_ratio)
	var new_scale: float = 1.0 / target_ratio
	self.scale = Vector2(new_scale, new_scale)
