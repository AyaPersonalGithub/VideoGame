extends Node
var score = 0
var level = 1
var message_label
var score_label

var food_scene = preload("res://scenes/food.tscn")
var goal_scene = preload("res://scenes/goal.tscn")
var enemy_scene = preload("res://scenes/enemy.tscn")
var tile_map_layer
var goal
@onready var food_container = $Foods
@onready var enemy_container = $Enemies
@onready var player = $Player
@onready var hud = $HUD
@onready var level_container = $Levels
@onready var goal_container = $Goal

const COIN_ATLAS_COORDS = Vector2i(17, 8) # update this if needed
const GOAL_ATLAS_COORDS = Vector2i(14, 9) # update this if needed
const ENEMY_ATLAS_COORDS = Vector2i(12, 7) #source 2
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
	
func _ready() -> void:		
#	$Goal.goal_reached.connect(on_goal_reached)
#	for food in $Foods.get_children():
#		food.food_obtained.connect(on_food_obtained)	
	message_label = $HUD.find_child("MessageLabel") as Label
	score_label = $HUD.find_child("ScoreLabel") as Label
	init_level(level) # load level 1 at the beginning
	$Killzone.player_killed.connect(_on_killzone_player_killed)
	
func init_level(level: int) -> void:
	# unload the old level
	unload_old_level()
	# reset player positiond
	player.position = Vector2(0, 0)
	# load the new level
	#tile_map_layer = load("res://scenes/levels/level%d.tscn" % level).instantiate()
	#add_child(tile_map_layer)
	tile_map_layer = load("res://scenes/levels/level%d.tscn" %level)		
	var  new_map_layer = tile_map_layer.instantiate()
	var count = new_map_layer.get_child_count()
	print("init child count", count)
	level_container.add_child(new_map_layer)
	#for i in range(count):
		#print("i is ", i)
	var ground_map_layer = new_map_layer.get_node("map")		
	#level_container.add_child(ground_map_layer)
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
			new_enemy.find_child("Killzone").player_killed.connect(_on_killzone_player_killed)
			ground_map_layer.set_cell(cell, -1)	

func on_goal_reached() -> void:
	if level < 3:
		level += 1
		init_level(level)
	else:
		message_label.text = "Congrats! Well done!"
		message_label.visible = true
	
func on_food_obtained() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
	print("Score: " + str(score))
	
func _on_killzone_player_killed() -> void:
	message_label.text = "Oh no >_< Game over!"
	message_label.visible = true
	#player.animated_sprite.play("hit")
	get_tree().paused = true # pause the game
#	$Sounds/DisappearSound.play()
