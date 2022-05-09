extends Node

var module_data
var all_modules = []


func _ready():
	module_data = load_module_data()
	for module in module_data:
		all_modules.append(module)
	
func load_module_data():
	var file = File.new()
	file.open("res://full_module_data.json", file.READ)
	var text = file.get_as_text()
	var loaded_module_data = JSON.parse(text).result
	return loaded_module_data
