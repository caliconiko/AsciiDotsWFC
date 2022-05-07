extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

var do_magic = false

onready var text_box = $RichTextLabel
onready var ticks_label = $Ticks

var ticks = 0

func _ready():
	seed(1)
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(80,27),Global.module_data)

func _process(_delta):
	text_box.text = wfc.as_string()
	ticks_label.text = str(ticks)
	if wfc.is_broken():
		redo_magic()
	
	if not wfc.is_collapsed() and do_magic:
		ticks+=1
		wfc.iterate()
	else:
		do_magic = false

func redo_magic():
	ticks = 0
	wfc.initialize()
	do_magic = true

func _on_Button_pressed():
	redo_magic()
