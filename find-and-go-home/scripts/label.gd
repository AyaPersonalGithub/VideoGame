extends Label

func _process(delta):
	text = str(Highscores.get_highscore_table_string())
