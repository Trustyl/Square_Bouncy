extends CanvasItem

const Obstacle = preload("res://Actors/Obstacle/Obstacle.gd")
const ObstacleSpawnData = preload("res://ObstacleSpawnData.gd")
const ObstaclePrefab = preload("res://Actors/Obstacle/Obstacle.tscn")
const Indicator = preload("res://Actors/Indicator/Indicator.gd")
const IndicatorPrefab = preload("res://Actors/Indicator/Indicator.tscn")

## Determines whether the spawner is currently working.
var active: bool = false

## The queue of the obstacles to spawn.
var spawn_queue: Array = []

## Counts down how many spawn events have to pass
## before a pattern could be spawned.
var pattern_countdown: int = 3

func _ready():
	var _err: int
	_err = StateManager.connect("died", self, "on_player_died")
	_err = StateManager.connect("respawned", self, "on_player_respawned")

func on_player_died():
	active = false

func on_player_respawned():
	active = true
	spawn_queue.clear()

func on_theme_changed(curr_theme: GameTheme, _next_theme: GameTheme):
	self.modulate = curr_theme.obstacle_color

func _process(dt: float):

	# Spawn and count time only when alive
	if not active:
		return

	for data in spawn_queue:
		(data as ObstacleSpawnData).timer -= dt

	while spawn_queue.size() > 0 && spawn_queue.front().timer <= 0.0:
		var spawn_data = spawn_queue.pop_front() as ObstacleSpawnData

		# The direction from where the obstacle will approach
		var dir = sign(spawn_data.initial_position.x)

		var obstacle: Obstacle = ObstaclePrefab.instance() as Obstacle
		obstacle.position = spawn_data.initial_position
		obstacle.speed = spawn_data.speed
		self.add_child(obstacle)

		var indicator: Indicator = IndicatorPrefab.instance() as Indicator
		indicator.position = Vector2(340.0 * dir, obstacle.position.y)
		indicator.scale.x *= dir
		indicator.set_obstacle(obstacle)
		self.add_child(indicator)

	# If there are no obstacles to spawn, make some new ones
	if spawn_queue.empty():
		if pattern_countdown <= 0 && randi() % 4 == 0:
			pattern_countdown = 3
			enqueue_pattern()
		else:
			pattern_countdown -= 1
			enqueue_single_random()

## Given the current run time,
## suggests a time until the next obstacle spawn.
func calc_suggested_timer(current_seconds: float) -> float:
	return 1.5 - min(0.8, current_seconds * 0.013)

## Suggests a time until the next obstacle spawn.
func compute_suggested_timer() -> float:
	return calc_suggested_timer(ScoreManager.get_time_current())

## Randomizes a single obstacle data and enqueues it to spawn later.
func enqueue_single_random():
	var spawn_data = ObstacleSpawnData.new()
	spawn_data.timer = compute_suggested_timer()
	spawn_data.speed = Vector2(Collections.random([300.0, -300.0]), 0.0)
	spawn_data.initial_position = Vector2(spawn_data.speed.x * -2.5, Collections.random([96.0, 48.0, 0.0, -48.0, -96.0]))
	spawn_queue.push_back(spawn_data)

## Selects a random, but predetermined obstacle pattern
## and enqueues it for it to spawn.
func enqueue_pattern():
	var pattern_index = randi() % 1
	var spawn_data: ObstacleSpawnData
	match pattern_index:
		0:
			var pos_y = Collections.random([96.0, -96.0])

			spawn_data = ObstacleSpawnData.new()
			spawn_data.timer = compute_suggested_timer()
			spawn_data.speed = Vector2(Collections.random([300.0, -300.0]), 0.0)
			spawn_data.initial_position = Vector2(spawn_data.speed.x * -2.5, pos_y)
			spawn_queue.push_back(spawn_data)

			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)

			spawn_data = copy_data(spawn_data)
			spawn_data.initial_position.y = 0.0
			spawn_data.timer += compute_suggested_timer()
			spawn_queue.push_back(spawn_data)

			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)

			spawn_data = copy_data(spawn_data)
			spawn_data.initial_position.y = -pos_y
			spawn_data.timer += compute_suggested_timer()
			spawn_queue.push_back(spawn_data)

			spawn_data = copy_data(spawn_data)
			spawn_data.speed *= -1.0
			spawn_data.initial_position.x *= -1.0
			spawn_queue.push_back(spawn_data)

## Duplicates a spawn data object.
func copy_data(data: ObstacleSpawnData) -> ObstacleSpawnData:
	var copy = ObstacleSpawnData.new()
	copy.initial_position = data.initial_position
	copy.speed = data.speed
	copy.timer = data.timer
	return copy
