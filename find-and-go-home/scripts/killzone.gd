extends Area2D
signal player_damaged

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_damaged.emit()
