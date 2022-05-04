extends Node

var obstacle: Node2D

func _ready():
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_respawned():
	queue_free()

func set_obstacle(o: Node2D):
	obstacle = o

func _process(dt: float):
	if obstacle != null:
		if abs(obstacle.position.x) < 360.0:
			queue_free()
