extends Node

const SAVE_PATH: String = "user://best.save"

## If the game save exists, returns the saved top score.
## Otherwise returns a provided fallback.
func load_best_score(fallback: int) -> int:

	var save = File.new()
	if not save.file_exists(SAVE_PATH):
		print("Save file does not exist")
		return fallback

	save.open(SAVE_PATH, File.READ)
	if save.get_len() < 8:
		save.close()
		printerr("Save file exists, but has no valid contents")
		return fallback

	# The smallest JSON save, '{"best":0}', is 10 chars long
	# We can use this fact to determine the save type
	var best: int = fallback
	if save.get_len() == 8:
		print("Save data seems to be a single integer")
		best = load_best_score_binary(save)
	else:
		print("Save data seems to be a JSON document")
		best = load_best_score_json(save, fallback)

	save.close()
	print("Loaded save data, best time is ", (float(best) / 1000000.0), "s")
	return best

## Loads the best score from a saved JSON document.
func load_best_score_json(save: File, fallback: int) -> int:
	save.seek(0)
	var json = JSON.parse(save.get_line())
	if json.error == OK:
		if json.result.has("best"):
			var best = json.result["best"]
			print("Save data is a valid JSON.")
			return int(best)
		else:
			print("Save data is a valid JSON, but does not have best score")
			return fallback

	print("Save data is not a valid JSON.")
	return fallback

## Loads the best score saved as a single 64-bit integer.
func load_best_score_binary(save: File) -> int:
	save.seek(0)
	return save.get_64()

## Attempts to save the provided score to a persistent file.
func save_best_score(score: int):
	var save = File.new()
	save.open(SAVE_PATH, File.WRITE) # truncates
	save.store_64(score)
	save.close()
