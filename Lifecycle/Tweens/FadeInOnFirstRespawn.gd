extends CanvasItem

onready var tween: Tween = $Tween as Tween

func _ready():
	self.modulate = Color.transparent
	var _err = StateManager.connect("respawned", self, "on_respawn", [], CONNECT_ONESHOT)

func on_respawn():
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 0.5)
	tween.start()
