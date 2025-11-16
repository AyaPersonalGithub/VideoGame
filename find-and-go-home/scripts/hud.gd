extends CanvasLayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		print("press quit")		
		get_tree().paused = true
		$Quit.visible = true
		
func _on_yes_button_pressed() -> void:
	get_tree().quit()

func _on_no_button_pressed() -> void:	
		print("press continue")		
		get_tree().paused = false
		$Quit.visible = false
