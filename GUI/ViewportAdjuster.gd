extends Node

onready var viewport: Viewport = get_viewport()
export var target_width: int = 720

func _ready():
	var _err: int = viewport.connect("size_changed", self, "adjust_size")
	adjust_size()

## Changes the viewport size so that
## the screen is always `target_width` units wide.
func adjust_size():
	var current_size: Vector2 = OS.window_size
	var scale_factor: float = float(target_width) / float(current_size.x)
	var new_size: Vector2 = current_size * scale_factor
	viewport.set_size_override(true, new_size)
