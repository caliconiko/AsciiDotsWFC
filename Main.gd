extends Control

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var wfc

var do_magic = false
var prev_do_magic = false

onready var text_box = $RichTextLabel
onready var ticks_label = $Ticks

var ticks = 0

func _ready():
	seed(1)
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
	wfc = WFC.new(Vector2(4,4),Global.module_data)
	print(wfc.get_possible_neighbours(['.', '~'], Vector2.DOWN))

func _process(_delta):
	text_box.text = wfc.as_string()
	ticks_label.text = str(ticks)
	if not wfc.is_collapsed() and do_magic:
		ticks+=1
		wfc.iterate()
	else:
		do_magic = false
		if prev_do_magic:
			var file = File.new()
			file.open("res://wf_log.txt", File.WRITE)
			file.store_var(str(wfc.wf_log))
			file.close()
			wfc.wf_log=""
	prev_do_magic = do_magic

func _on_Button_pressed():
	ticks = 0
	wfc.initialize()
	do_magic = true
