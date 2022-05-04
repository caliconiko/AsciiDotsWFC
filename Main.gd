extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

var do_magic = false

onready var text_box = $RichTextLabel

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(40,16),Global.module_data)
#	wfc.set_possibilities_at(Vector2(0,0), ["|"])

func _process(_delta):
	if not wfc.is_collapsed() and do_magic:
		wfc.iterate()
		text_box.text = wfc.as_string()
	else:
		do_magic = false


func _on_Button_pressed():
	wfc.initialize()
	do_magic = true
