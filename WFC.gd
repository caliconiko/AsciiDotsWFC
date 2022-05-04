extends Node

class_name WFC

var wave_function = []
var size:Vector2

func _init(size:Vector2, module_data:Dictionary):
	wave_function = initialize(size, module_data)
	
func initialize(new_size:Vector2, module_data:Dictionary):
	var all_modules = module_data.keys()
	size = new_size
	
	var new_wave_function = []
	for _y in range(size.y):
		var x = []
		for _x in range(size.x):
			x.append(all_modules.duplicate())
		new_wave_function.append(x)
		
	return new_wave_function

func get_min_entropy_coords():
	var min_entropy = INF
	
	for line in wave_function:
		for c in line:
			if len(c)<min_entropy and len(c)>1:
				min_entropy = len(c)
				
	var potential_coords = []
	
	for j in range(size.y):
		for i in range(size.x):
			var c = wave_function[j][i]
			if len(c) == min_entropy:
				potential_coords.append(Vector2(i, j))
	print(potential_coords)
	return potential_coords[randi() % potential_coords.size()]
	
func collapse_at(coords:Vector2):
	var c = wave_function[coords.y][coords.x]
	wave_function[coords.y][coords.x] = [c[randi() % len(c)]]

func iterate():
	var coords = get_min_entropy_coords()
	collapse_at(coords)
	
func get_valid_dirs(coords):
	var valid_dirs_arr = []
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var other_coords = dir+coords
		var x_is_valid = other_coords.x>-1 and other_coords.x<size.x
		var y_is_valid = other_coords.y>-1 and other_coords.y<size.y
		if  x_is_valid and y_is_valid:
			valid_dirs_arr.append(dir)
			
	return valid_dirs_arr

func get_possible_neighbours(coords, dir):
	var c = wave_function[coords.y][coords.x]
	var all_possibilities = []
	var dir_str = Global.vector_to_string[dir]
	for module in c:
		var module_data = Global.module_data[module]
		var possibilities = module_data[Global.POSSIBLE_NEIGHBOURS][dir_str]
		for possibility in possibilities:
			if not all_possibilities.has(possibility):
				all_possibilities.append(possibility)
				
	return all_possibilities

func is_collapsed():
	for line in wave_function:
		for c in line:
			if len(c)>1:
				return false
				
	return true
