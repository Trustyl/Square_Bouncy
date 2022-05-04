extends Sprite

enum ThemeToUse {
	CURRENT,
	NEXT,
}

export (ThemeToUse) var mode = ThemeToUse.CURRENT

func on_theme_changed(curr_theme: GameTheme, next_theme: GameTheme):
	match mode:
		ThemeToUse.CURRENT:
			self.texture = curr_theme.background_image
		ThemeToUse.NEXT:
			self.texture = next_theme.background_image
