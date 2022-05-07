extends Node

class_name WFC

var wave_function = []
var size:Vector2
var stack = []
var module_data
var wf_log = ""

func _init(start_size:Vector2, module_data_dict:Dictionary):
	size=start_size
	module_data = module_data_dict
	initialize()

func as_string():
	"""Get wave function in nice printable form"""
	var lines = ""
	for line in wave_function:
		var str_line = ""
		for c in line:
			if len(c)>0:
				str_line+=c[0][0]
			else:
				str_line+="?"
		lines+=str_line
		lines+="\n"
		
	return lines

func get_possibilities_at(coords):
	return wave_function[coords.y][coords.x]
	
func set_possibilities_at(coords, possibilities):
	wave_function[coords.y][coords.x] = possibilities

func initialize():
	"""Make new wavefunction"""
	var all_modules = module_data.keys()
	wf_log = ""

	var new_wave_function = []
	for _y in range(size.y):
		var x = []
		for _x in range(size.x):
			x.append(all_modules.duplicate())
		new_wave_function.append(x)
		
	wave_function = new_wave_function

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
	return potential_coords[randi() % potential_coords.size()]
	
func collapse_at(coords:Vector2):
	var c = get_possibilities_at(coords)
	wave_function[coords.y][coords.x] = [c[randi() % len(c)]]

func log_a_thing(thing):
	wf_log+='\n'
	wf_log+=str(thing)

func log_wave_function():
	for line in wave_function:
		log_a_thing(line)
	log_a_thing("")

func iterate():
	var coords = get_min_entropy_coords()
	collapse_at(coords)
	propagate(coords)

func set_and_propagate(coords, possibilities):
	set_possibilities_at(coords, possibilities)
	propagate(coords)

func constrain(coords, module):
	"""Remove a module from the possibilities at coords"""
	var possibilities = get_possibilities_at(coords)
	
	if len(possibilities)>0:
		var new_possibilities = []
		for possibility in possibilities:
			if possibility != module:
				new_possibilities.append(possibility)
				
		wave_function[coords.y][coords.x] = new_possibilities

func propagate(coords):
	stack.append(coords)
	
	while len(stack)>0:
		var cur_coords = stack.pop_back()
		
		for dir in get_valid_dirs(cur_coords):
			var other_coords = cur_coords+dir
			var other_possible_modules = get_possibilities_at(other_coords).duplicate()
			
			var possible_neighbours = get_possible_neighbours_at(cur_coords, dir)
			
			if len(other_possible_modules)==0:
				continue
				
			for other_module in other_possible_modules:
				if not other_module in possible_neighbours:
					constrain(other_coords, other_module)
					if not other_coords in stack:
						stack.append(other_coords)
	
func get_valid_dirs(coords):
	var valid_dirs_arr = []
	for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var other_coords = dir+coords
		var x_is_valid = other_coords.x>-1 and other_coords.x<size.x
		var y_is_valid = other_coords.y>-1 and other_coords.y<size.y
		if  x_is_valid and y_is_valid:
			valid_dirs_arr.append(dir)
			
	return valid_dirs_arr

func get_possible_neighbours_at(coords, dir):
	var c = get_possibilities_at(coords)
	return get_possible_neighbours(c, dir)
	
func get_possible_neighbours(possibilities, dir):
	var all_possibilities = []
	var dir_str = Global.vector_to_string[dir]
	for module in possibilities:
		var cur_module_data = Global.module_data[module]
		if cur_module_data[Global.POSSIBLE_NEIGHBOURS].keys().has(dir_str):
			var neighbour_possibilities = cur_module_data[Global.POSSIBLE_NEIGHBOURS][dir_str]
			
			for neighbour_possibility in neighbour_possibilities:
				if not all_possibilities.has(neighbour_possibility):
					all_possibilities.append(neighbour_possibility)

	return all_possibilities

func is_collapsed():
	for line in wave_function:
		for c in line:
			if len(c)>1:
				return false
				
	return true
