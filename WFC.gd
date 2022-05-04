extends Node

class_name WFC

var wave_function = []

func _init(size:Vector2, module_data:Dictionary):
	wave_function = initialize(size, module_data)
	
func initialize(size:Vector2, module_data:Dictionary):
	var all_modules = module_data.keys()
	
	var new_wave_function = []
	for _y in range(size.y):
		var x = []
		for _x in range(size.x):
			x.append(all_modules.duplicate())
		new_wave_function.append(x)
		
	return new_wave_function

func iterate():
	pass
	

func is_collapsed():
	for line in wave_function:
		for c in line:
			if len(c)>1:
				return false
				
	return true
