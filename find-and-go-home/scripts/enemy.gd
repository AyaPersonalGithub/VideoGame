extends Node2D
const SPEED = 200
var direction = 1
@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast_right = $RayCastRight
@onready var raycast_left = $RayCastLeft
func _physics_process(delta: float) -> void:
	
	#if raycast_right.is_colliding() and raycast_right.get_collider() is not CharacterBody2D:
		#direction = -1 # move left if we hit a wall on the right
		#animated_sprite.flip_h = false
	#if raycast_left.is_colliding() and raycast_left.get_collider() is not CharacterBody2D:
		#direction = 1 # move right if we hit a wall on the left
		#animated_sprite.flip_h = true
	if direction == 1:
		if not raycast_right.is_colliding() or raycast_right.get_collider() is CharacterBody2D:
			direction = -1 # move left if we hit a wall on the right
			animated_sprite.flip_h = false
			print("change to left")
	elif direction == -1:
		if not raycast_left.is_colliding() or raycast_left.get_collider() is  CharacterBody2D:
			direction = 1 # move right if we hit a wall on the left
			animated_sprite.flip_h = true
			print("change to right")
	position.x += direction * SPEED * delta
	print("right raycast: ",raycast_right.is_colliding() )
	print("left raycast: ",raycast_left.is_colliding() )
	print("direction: ",direction)
