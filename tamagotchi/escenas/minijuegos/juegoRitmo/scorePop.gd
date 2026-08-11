extends Control

func setInfoPuntaje(texto:String):
	$RichTextLabel.text="[center]"+texto
	match texto:
		"PERFECTO":
			$RichTextLabel.set("theme_override_colors/font_outline_color", Color("e952daff"))
			$RichTextLabel.set("theme_override_colors/default_color", Color("c7acd4"))
		"GENIAL":
			$RichTextLabel.set("theme_override_colors/font_outline_color", Color("2d9b87ff"))
			$RichTextLabel.set("theme_override_colors/default_color", Color("6de7d9ff"))

		"BIEN":
			$RichTextLabel.set("theme_override_colors/font_outline_color", Color("2873afff"))
			$RichTextLabel.set("theme_override_colors/default_color", Color("77b7f2ff"))
		"OK":
			$RichTextLabel.set("theme_override_colors/font_outline_color", Color("a07239ff"))
			$RichTextLabel.set("theme_override_colors/default_color", Color("c89352ff"))
		_:
			$RichTextLabel.set("theme_override_colors/font_outline_color", Color("000000ff"))
			$RichTextLabel.set("theme_override_colors/default_color",Color("ffffffff"))
