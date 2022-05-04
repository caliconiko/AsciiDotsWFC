extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(4,4),Global.module_data)
	wfc.collapse_at(Vector2(0,0))
	print(wfc.wave_function[0][0])
	print(wfc.get_possible_neighbours(Vector2(0,0), Vector2.DOWN))
	
func do_magic():
	while not wfc.is_collapsed():
		pass
		
