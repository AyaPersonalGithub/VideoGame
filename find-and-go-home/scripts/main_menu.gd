extends Node2D
var next_scene = preload("res://scenes/game.tscn")


func _on_start_button_toggled(toggled_on: bool) -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
