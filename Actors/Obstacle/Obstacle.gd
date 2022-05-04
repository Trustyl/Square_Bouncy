extends Area2D

export var speed: Vector2 = Vector2(0.0, 0.0)

func _ready():
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_respawned():
	queue_free()

func _process(dt: float):
	if StateManager.current_state == StateManager.State.PLAYING:
		position += speed * dt
