extends Node2D

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_end_button_pressed() -> void:
	get_tree().quit()
