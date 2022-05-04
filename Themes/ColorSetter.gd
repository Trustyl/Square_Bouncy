extends CanvasItem

enum ThemeToUse {
	CURRENT,
	NEXT,
}

export (ThemeToUse) var mode = ThemeToUse.CURRENT

func on_theme_changed(curr_theme: GameTheme, next_theme: GameTheme):
	match mode:
		ThemeToUse.CURRENT:
			self.modulate = curr_theme.boundary_color
		ThemeToUse.NEXT:
			self.modulate = next_theme.boundary_color
