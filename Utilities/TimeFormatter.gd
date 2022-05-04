extends Node

## Represents seconds as a string.
func format(seconds: float) -> String:
	var text = ""
	if seconds > 60.0:
		var minutes = int(floor(seconds / 60.0))
		text = "%d:" % minutes
		seconds = fmod(seconds, 60.0)
	if seconds < 10.0:
		text += "0"
	text += "%.2f" % seconds
	return text
