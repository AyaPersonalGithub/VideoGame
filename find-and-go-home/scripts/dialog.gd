extends CanvasLayer
signal continue_button_pressed

func _on_button_pressed() -> void:
	get_tree().paused = false
	continue_button_pressed.emit()
	
