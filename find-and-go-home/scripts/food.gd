extends Area2D

signal food_obtained

func _on_body_entered(body: Node2D) -> void:
	print("food get emit")
	food_obtained.emit()
	queue_free()
