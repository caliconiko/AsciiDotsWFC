extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

var do_magic = false

onready var text_box = $RichTextLabel
onready var ticks_label = $Ticks

var ticks = 0

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(40,16),Global.module_data)

func _process(_delta):
	text_box.text = wfc.as_string()
	ticks_label.text = str(ticks)
	if not wfc.is_collapsed() and do_magic:
		ticks+=1
		wfc.iterate()
	else:
		do_magic = false


func _on_Button_pressed():
	ticks = 0
	wfc.initialize()
	do_magic = true
