extends Node
const max_highscore_count = 3
var highscores = []
var file_name = "res://save.dat"
func _ready() -> void:
	init()
	
func init():
	if FileAccess.file_exists (file_name):
		print("file exist")
		load_from_file()
	print(get_highscore_table_string())
	
func get_highscore_table_string () -> String:
	var s = "Highscore Table:" + "\n"
	s = s + "===========================" + "\n"
	if highscores:
		for i in range(highscores.size()):
			s = s + str(i+1) +". level: " + str(highscores[i][0]) + " score: " + str(highscores[i][1]) + " Time: "+ Time.get_datetime_string_from_unix_time(highscores[i][2]) + "\n"
		s = s + "==========================="
	return s

func update_highscore(level, new_score):
	var new_converted_score = level*10 + new_score
	if highscores.size() < max_highscore_count:
		add_highscore(level,new_score)
	else:
		for i in range( highscores.size()):
			if new_converted_score > highscores [i][0]*10+highscores [i][1]:
				add_highscore(level, new_score)
				return

				
func add_highscore(level, new_score):
	highscores.append([level, new_score , Time.get_unix_time_from_system()])
	print("New highscore ! level:", highscores[-1][0], " score: ", highscores[-1][1], " @ ",Time.get_datetime_string_from_unix_time(highscores [-1][2]))
	highscores.sort_custom(func (a, b): return (a[1] > b[1] if a[0] == b[0] else a[0] > b[0]))
	highscores = highscores.slice (0, max_highscore_count)
	save_to_file()
	print(get_highscore_table_string())

func save_to_file():
	var f = FileAccess.open (file_name, FileAccess.WRITE)
	f.store_var(highscores)
	f.close()
	
func load_from_file():
	var f =	FileAccess.open(file_name, FileAccess.READ)
	if f:
		f.seek(0)
		highscores = f.get_var()
		print("read file:", highscores)
		f.close()
	else:
		printerr("cannot read file")
