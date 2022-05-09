extends Node

class_name WFC

var wave_function = []
var size:Vector2
var stack = []
var module_data
var all_possibilities
var weights = {}

const POSSIBLE_NEIGHBOURS = "possible_neighbours"
const WEIGHT = "weight"
const VECTOR_TO_STRING = {
	Vector2.UP : "up",
	Vector2.DOWN : "down",
	Vector2.LEFT : "left",
	Vector2.RIGHT : "right"
}

func _init(start_size:Vector2, module_data_dict:Dictionary):
	size=start_size
	module_data = module_data_dict
	all_possibilities = module_data.keys()
	
	for module in module_data.keys():
		weights[module] = module_data[module][WEIGHT]
		
	initialize()

func as_string():
	"""Get wave function in nice printable form"""
	var lines = ""
	for line in wave_function:
		var str_line = ""
		for c in line:
			var character
			if len(c)>0:
				character=c[0][0]
			else:
				character="?"
			str_line+=character
		lines+=str_line
		lines+="\n"
		
	return lines

func get_possibilities_at(coords:Vector2):
	return wave_function[coords.y][coords.x]
	
func set_possibilities_at(coords:Vector2, possibilities):
	wave_function[coords.y][coords.x] = possibilities

func initialize():
	"""Make new wavefunction"""

	var new_wave_function = []
	for _y in range(size.y):
		var x = []
		for _x in range(size.x):
			x.append(all_possibilities.duplicate())
		new_wave_function.append(x)
		
	wave_function = new_wave_function
	
func get_shannon_entropy_at(coords:Vector2):
	var possibilities = get_possibilities_at(coords)
	
	var sum_of_weights = 0
	var sum_of_weight_log_weights = 0
	for possibility in possibilities:
		var weight = weights[possibility]
		
		sum_of_weights+=weight
		sum_of_weight_log_weights+=weight*log(weight)
		
	return log(sum_of_weights) - (sum_of_weight_log_weights / sum_of_weights)

func get_min_entropy_coords():
	var min_entropy = INF
	var min_entropy_coords:Vector2
	
	for x in range(size.x):
		for y in range(size.y):
			var current_coords = Vector2(x,y)
			if len(get_possibilities_at(current_coords)) == 1:
				continue
				
			var entropy = get_shannon_entropy_at(current_coords)
			var entropy_plus_noise = entropy - (randf()/1000)
			
			if entropy_plus_noise < min_entropy:
				min_entropy = entropy_plus_noise
				min_entropy_coords = current_coords
				
	return min_entropy_coords
	
func collapse_at(coords:Vector2):
	var possibilities = get_possibilities_at(coords)
	
	var valid_weights = {}
	for module in weights.keys():
		if module in possibilities:
			valid_weights[module] = weights[module]
			
	var total_weights = 0
	for valid_weight in valid_weights.values():
		total_weights+=valid_weight
		
	var rnd = randf()*total_weights
	
	var chosen
	for module in valid_weights.keys():
		var weight = valid_weights[module]
		rnd -= weight
		if rnd < 0:
			chosen = module
			break

	wave_function[coords.y][coords.x] = [chosen]

func iterate():
	var coords = get_min_entropy_coords()
	collapse_at(coords)
	propagate(coords)

func set_and_propagate(coords:Vector2, possibilities):
	set_possibilities_at(coords, possibilities)
	propagate(coords)

func constrain(coords:Vector2, module):
	"""Remove a module from the possibilities at coords"""
	var possibilities = get_possibilities_at(coords)
	
	var new_possibilities = []
	for possibility in possibilities:
		if possibility != module:
			new_possibilities.append(possibility)
	

	set_possibilities_at(coords, new_possibilities)

func propagate(coords:Vector2):
	stack.append(coords)
	
	while len(stack)>0:
		var current_coords = stack.pop_back()
		
		for dir in get_valid_dirs(current_coords):
			var other_coords = current_coords+dir
			var other_possible_modules = get_possibilities_at(other_coords).duplicate()
			
			var possible_neighbours = get_possible_neighbours_at(current_coords, dir)
			
			if len(other_possible_modules)==0:
				continue
				
			for other_module in other_possible_modules:
				if not other_module in possible_neighbours:
					constrain(other_coords, other_module)
					if not other_coords in stack:
						stack.append(other_coords)
	
func get_valid_dirs(coords:Vector2):
	var valid_dirs_arr = []
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var other_coords = dir+coords
		var x_is_valid = other_coords.x>-1 and other_coords.x<size.x
		var y_is_valid = other_coords.y>-1 and other_coords.y<size.y
		if  x_is_valid and y_is_valid:
			valid_dirs_arr.append(dir)
			
	return valid_dirs_arr

func get_possible_neighbours_at(coords:Vector2, dir):
	var c = get_possibilities_at(coords)
	return get_possible_neighbours(c, dir)
	
func get_possible_neighbours(possibilities, dir):
	var all_neighbour_possibilities = []
	var dir_str = VECTOR_TO_STRING[dir]
	for module in possibilities:
		var cur_module_data = module_data[module]
		if cur_module_data[POSSIBLE_NEIGHBOURS].keys().has(dir_str):
			var neighbour_possibilities = cur_module_data[POSSIBLE_NEIGHBOURS][dir_str]
			
			for neighbour_possibility in neighbour_possibilities:
				if not all_neighbour_possibilities.has(neighbour_possibility):
					all_neighbour_possibilities.append(neighbour_possibility)

	return all_neighbour_possibilities

func is_collapsed():
	for line in wave_function:
		for c in line:
			if len(c)>1:
				return false
				
	return true

func is_broken():
	for line in wave_function:
		for c in line:
			if len(c)<1:
				return true
				
	return false
