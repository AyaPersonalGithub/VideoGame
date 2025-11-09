class_name Player
extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -1500.0
@onready var animated_sprite = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handle duck.
	var is_ducking = false
	if Input.is_action_pressed("duck"):
		is_ducking = true
	if not is_on_floor():
		velocity += get_gravity() * delta * 2 # make it fall faster
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction: # != 0
		velocity.x = direction * SPEED
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Choose an animation based on the character's current action.
	if is_ducking:
		animated_sprite.play("duck")
	elif velocity.y != 0:
		animated_sprite.play("jump")
	elif velocity.x != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
		
	velocity.x += SPEED/2	
	move_and_slide()
