extends Node
var score = 0
var currentlevel = 1
var message_label
var score_label
var map_move_speed = 50
var food_scene = preload("res://scenes/food.tscn")
var goal_scene = preload("res://scenes/goal.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var ship_part_scene = preload("res://scenes/ship_part.tscn")
var tile_map_layer
var goal
var segments = [
	preload("res://scenes/levels/level1_1.tscn"),
	preload("res://scenes/levels/level1_2.tscn"),
	preload("res://scenes/levels/level1_3.tscn")
]
var levelSegmentLength = 3200
@onready var food_container = $Foods
@onready var enemy_container = $Enemies
@onready var player = $Player
@onready var hud = $HUD
@onready var level_container = $Levels
@onready var goal_container = $Goal
@onready var boss = $Boss
@onready var ship_parts_container = $ShipParts
@onready var hearts_parent =$"HUD/Heart_bar"
@onready var popup_dialog =$Popup

var hearts_list : Array[TextureRect]
var health = 5
const COIN_ATLAS_COORDS = Vector2i(17, 8) # update this if needed
const GOAL_ATLAS_COORDS = Vector2i(14, 9) # update this if needed
const ENEMY_ATLAS_COORDS = Vector2i(12, 7) #source 2
const GEAR_ATLAS_COORDS = Vector2i(10, 5) #source 2
func unload_old_level() -> void:
	#if tile_map_layer:
		#tile_map_layer.queue_free()
	print("unload child count: ",level_container.get_child_count())
	for level in level_container.get_children():
		level.queue_free()
#	for tile_map_layer.get_children():
#		print("tilemap has child")
	for food in food_container.get_children():
		food.queue_free()		
	for goal in goal_container.get_children():
		goal.queue_free()
	for enemy in enemy_container.get_children():
		enemy.queue_free()
	for ship_part in ship_parts_container.get_children():
		ship_part.queue_free()
	
func _ready() -> void:		
#	$Goal.goal_reached.connect(on_goal_reached)
#	for food in $Foods.get_children():
#		food.food_obtained.connect(on_food_obtained)	
	message_label = $HUD.find_child("MessageLabel") as Label
	score_label = $HUD.find_child("ScoreLabel") as Label
	init_level(currentlevel) # load level 1 at the beginning
	$Killzone.player_damaged.connect(_on_killzone_player_killed)
	#boss.find_child("Killzone").player_damaged.connect(_on_killzone_player_killed)
	boss.player_catched.connect(_on_killzone_player_killed)	
	#show health_bar
	for child in hearts_parent.get_children():
		hearts_list.append(child)
	popup_dialog.continue_button_pressed.connect(on_popup_button_pressed)

func spawm_inst(x, y, level):
	var id = randi() % len(segments)
	id += 1
	print(" id: ", id, "level: ",level)
	var segment = load("res://scenes/levels/level%s_%s.tscn" %[level, id])
	#for segment in range (segments.size()):		
	var inst = segment.instantiate()
	level_container.add_child(inst)
	inst.global_position = Vector2(x,0)
	#print("position of scene:",inst.global_position)
	#load cell of food and gears 
	var ground_map_layer = inst.get_node("map")		
	for cell in ground_map_layer.get_used_cells():		
		if ground_map_layer.get_cell_atlas_coords(cell) == COIN_ATLAS_COORDS:
			var new_food = food_scene.instantiate()
			food_container.add_child(new_food)
			new_food.position = ground_map_layer.to_global(ground_map_layer.map_to_local(cell))
			new_food.food_obtained.connect(on_food_obtained)
			ground_map_layer.set_cell(cell, -1)
		elif ground_map_layer.get_cell_atlas_coords(cell) == GOAL_ATLAS_COORDS:
			goal = goal_scene.instantiate()
			goal_container.add_child(goal)
			goal.position = ground_map_layer.to_global(ground_map_layer.map_to_local(cell))
			goal.goal_reached.connect(on_goal_reached)
			ground_map_layer.set_cell(cell, -1)
		elif ground_map_layer.get_cell_atlas_coords(cell) == ENEMY_ATLAS_COORDS:
			var new_enemy = enemy_scene.instantiate()
			enemy_container.add_child(new_enemy)
			new_enemy.position = ground_map_layer.to_global(ground_map_layer.map_to_local(cell))
			new_enemy.find_child("Killzone").player_damaged.connect(_on_killzone_player_killed)
			ground_map_layer.set_cell(cell, -1)				
		elif ground_map_layer.get_cell_atlas_coords(cell) == GEAR_ATLAS_COORDS:
			var new_ship_part = ship_part_scene.instantiate()
			ship_parts_container.add_child(new_ship_part)
			new_ship_part.position = ground_map_layer.to_global(ground_map_layer.map_to_local(cell))
			new_ship_part.gear_obtained.connect(on_gear_obtained)
			ground_map_layer.set_cell(cell, -1)	
			print("load gear")
		
func init_level(level: int) -> void:
	# unload the old level
	unload_old_level()
	# reset player positiond
	player.position = Vector2(0, 0)
	boss.position = Vector2(-200, -200)
	score = 0
	spawm_inst(0,0,currentlevel)
	spawm_inst(levelSegmentLength,0,currentlevel)

func _physics_process(delta: float) -> void:
	for level in level_container.get_children():
		level.position.x -=map_move_speed * delta
		#print("levl position: ",level.position.x)
		if level.position.x +levelSegmentLength < player.position.x-1024:
			spawm_inst(level.position.x + levelSegmentLength * 2, 0, currentlevel)
			level.queue_free()
			print("load a new segment")
	
	for food in food_container.get_children():
		food.position.x -=map_move_speed * delta
	for goal in goal_container.get_children():
		goal.position.x -=map_move_speed * delta
	for enemy in enemy_container.get_children():
		enemy.position.x -=map_move_speed * delta
	for ship_part in ship_parts_container.get_children():
		ship_part.position.x -=map_move_speed * delta
	if player.position.y >= 800:
		#reset player y position
		player.position.y = -100
		_on_killzone_player_killed()

	
func on_goal_reached() -> void:
	if currentlevel < 3:
		currentlevel += 1
		#init_level(currentlevel)		
		popup_dialog.visible = true
		get_tree().paused = true
	else:
		message_label.text = "Congrats! Well done!"
		message_label.visible = true
	
func on_food_obtained() -> void:
	health += 1
	update_heart_display()

func on_gear_obtained() ->void:	
	score += 1	
	if score >=2:
		score = 0
		on_goal_reached()
		print("collet gears and move to next level")		
	score_label.text = "Score: " + str(score)
	print("Score: " + str(score))
	
func _on_killzone_player_killed() -> void:
	print("health: ", health)	
	player.animated_sprite.play("hit")
	if health >1:
		health  -=1
		update_heart_display()
		#shall move back the 
	elif health <=1:		
		health  = 0
		update_heart_display()
		player.animated_sprite.play("hit")
		get_tree().paused = true # pause the game
		message_label.text = "Oh no >_< Game over!"
		message_label.visible = true
#	$Sounds/DisappearSound.play()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i <health
		
func on_popup_button_pressed():
	print("get continue button signal")
	popup_dialog.visible = false
	init_level(currentlevel)
