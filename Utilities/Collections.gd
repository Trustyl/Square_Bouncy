extends Node

func _ready():
	randomize()

## Returns a random element of the array.
func random(arr: Array):
	return arr[randi() % arr.size()]
