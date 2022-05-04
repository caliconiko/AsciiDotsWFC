extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(4,4),Global.module_data)
	do_magic()
	print(wfc.wave_function)
	
func do_magic():
	while not wfc.is_collapsed():
		
		wfc.iterate()
