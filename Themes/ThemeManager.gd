extends Node

## Contains all themes that can be activated.
export (Array, Resource) var available_themes

## Theme that is currently active.
export var current_theme: Resource

## Theme that will be activated after the next theme change.
export var next_theme: Resource

## This signal gets emitted whenever a theme is elected.
signal theme_changed(curr_theme, next_theme)

func _ready():
	StateManager.connect("respawned", self, "choose_next_theme")
	current_theme = Collections.random(available_themes)
	# The reason why we start with next == current is that
	# the state machine will emit a "Respawned" signal on game start
	# and we want the theme to stay after this event happens once
	next_theme = current_theme
	# Update the UI before the game starts
	emit_signal("theme_changed", current_theme, next_theme)

## Premotes a queued theme to active and queues a new, random theme
## that is different from the active one.
func choose_next_theme():
	current_theme = next_theme
	var candidates: Array = available_themes.duplicate(false)
	candidates.erase(current_theme)
	next_theme = Collections.random(candidates)
	emit_signal("theme_changed", current_theme, next_theme)
