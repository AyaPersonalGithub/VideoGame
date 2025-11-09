extends Node2D
const SPEED = 3
@onready var player = $"../Player"
var player_chase = false
	
func _physics_process(delta: float) -> void:
	if player_chase:
		if player != null:
			var player_pos = player.global_position
			#print("player position: ",player_pos, "enemy position: ",position)
			position += (player_pos - position).normalized() * SPEED
		else:
			print("cannot find player")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#find player
		player_chase = true


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		#print("lost player")	
		player_chase = false
