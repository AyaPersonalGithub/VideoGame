extends Node2D
var next_scene = preload("res://scenes/game.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_ok_button_pressed() -> void:
	$TextureRect.visible = false


func _on_how_to_play_button_pressed() -> void:
	$TextureRect.visible = true
