extends Node2D

func _ready() -> void:			
	$HighestScore.text = $Highscores.get_highscore_table_string()
	$HighestScore.visible = true #Highscores.get_highscore_table_string
func _on_retry_button_pressed() -> void:	
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_end_button_pressed() -> void:
	get_tree().quit()
