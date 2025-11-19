extends Node
const max_highscore_count = 3
var highscores = []
func init():
	if FileAccess.file_exists ("user://save.dat"):
		load_from_file()
	print(get_highscore_table_string())
func get_highscore_table_string () -> String:
	var s = "Highscore Table:" + "\n"
	s = s + "===========================" + "\n"
	for i in range(highscores.size()):
		s = s + str(i+1) +". " + str(highscores[i][0]) + " " + Time.get_datetime_string_from_unix_time(highscores[i][1]) + "\n"
	s = s + "==========================="
	return s

func update_highscore(new_score):
	if highscores.size() < max_highscore_count:
		add_highscore(new_score)
	else:
		for i in range( highscores.size()):
			if new_score > highscores [i][0]:
				add_highscore(new_score)
				return
				
func add_highscore(new_score):
	highscores.append([new_score , Time.get_unix_time_from_system()])
	print("New highscore ! ", highscores[-1][0], " @ ", Time.get_datetime_string_from_unix_time(highscores [1][1]))
	highscores.sort_custom(func (a, b): return (a[1] > b[1] if a[0] == b[0] else a[0] > b[0]))
	highscores = highscores.slice (0, max_highscore_count)
	save_to_file()
	print(get_highscore_table_string())

func save_to_file():
	var f = FileAccess.open ("user://save.dat", FileAccess.WRITE)
	f.store_var(highscores)
	f.close()
	
func load_from_file():
	var f =	FileAccess.open("user://save.dat", FileAccess.READ)
	highscores 	= f.get_var()
	f.close()
