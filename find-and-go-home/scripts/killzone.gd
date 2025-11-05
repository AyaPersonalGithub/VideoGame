extends Area2D
signal player_killed

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_killed.emit()
		print("player kill emit")
