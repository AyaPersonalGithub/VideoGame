extends Node2D
const SPEED = 3
@onready var player = $"../Player"
@onready var timer: Timer = $Timer # Get the Timer node
signal player_catched
var player_chase = false
func _ready():
	# Configure the timer (e.g., fire every 1 second, not one-shot, autostart off)
	timer.wait_time = 3.0
	timer.one_shot = false
	timer.autostart = false
	#$Killzone.player_damaged.connect(on_)

func _physics_process(delta: float) -> void:
	if player_chase:
		if player != null:
			var player_pos = player.global_position
			#print("player position: ",player_pos, "enemy position: ",position)
			position += (player_pos - position).normalized() * SPEED
		else:
			print("cannot find player")
			
func _on_detect_area_body_entered(body: Node2D) -> void:
	if body is Player:
		#find player and chase
		player_chase = true

func _on_detect_area_body_exited(body: Node2D) -> void:
	if body is Player:
		print("lost player")	
		player_chase = false
		
func _on_timer_timeout() -> void:
	# This function is called repeatedly while a body is inside
	print("time out")
	player_catched.emit()


func _on_catch_area_body_entered(body: Node2D) -> void:
	#catch player
	if body is Player:
		player_catched.emit()
		timer.start()
		print("timer start")
	
func _on_catch_area_body_exited(body: Node2D) -> void:
	#player run away
	if body is Player:
		timer.stop()
		print("timer stop")
