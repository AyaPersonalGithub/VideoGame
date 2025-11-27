extends Area2D

signal gear_obtained

func _on_body_entered(body: Node2D) -> void:
	#print("gear get emit")
	gear_obtained.emit()
	queue_free()
