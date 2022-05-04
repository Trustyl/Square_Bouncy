extends Node2D

onready var tween: Tween = $Tween as Tween

export var delay: float = 1.5
export var speed: float = 0.8
export var scale_alive: Vector2 = Vector2(0.0, 0.0)
export var scale_dead: Vector2 = Vector2(2.0, 2.0)

func _ready():
	StateManager.connect("died", self, "on_player_died")
	StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	tween.stop(self)
	tween.interpolate_callback(self, delay, "start_inflating")
	tween.start()

func start_inflating():
	tween.interpolate_property(self, "scale", scale_alive, scale_dead, speed)
	tween.start()

func on_player_respawned():
	tween.stop(self)
	self.scale = scale_alive
