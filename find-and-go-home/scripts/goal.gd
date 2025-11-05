extends Area2D
signal goal_reached
func _on_body_entered(body: Node2D) -> void:
	print("goal reach emit")
	goal_reached.emit()
