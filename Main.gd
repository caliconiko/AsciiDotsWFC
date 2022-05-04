extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)

var wfc

func _ready():
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(10,10),Global.module_data)
	
func do_magic():
	while not wfc.is_collapsed():
		pass
