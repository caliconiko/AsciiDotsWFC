extends Control

onready var text_box = $HBoxContainer/RichTextLabel
onready var ticks_label = $HBoxContainer/VBoxContainer/Ticks
onready var asciidots_ticks_label = $HBoxContainer/VBoxContainer/AsciiDotsTicks
onready var dot_count_label = $HBoxContainer/VBoxContainer/DotCount
onready var asciidotsery = $AsciiDotsery

onready var init_button = $HBoxContainer/VBoxContainer/InitButton
onready var step_button = $HBoxContainer/VBoxContainer/StepButton

var ticks = 0

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var DOT_COLOR = Color(0.976471, 0.14902, 0.447059)
var wfc

var do_magic = false

var dots = []
var dot_counts = [0]

export(int,0,90) var wave_function_width = 90
export(int,0,25) var wave_function_height = 25

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	dot_count_label.modulate = DOT_COLOR
	
	wfc = WFC.new(Vector2(wave_function_width,wave_function_height),Global.module_data)
	var s = "01234"
	s[0]=""
	s=s.insert(0, "asd")
	print(s)

func _process(_delta):
	text_box.bbcode_text = highlight_dots(wfc.as_string())
	ticks_label.text = str(ticks)
	asciidots_ticks_label.text = str(len(dot_counts))
	dot_count_label.text = str(dot_counts[-1])
	if wfc.is_broken():
		redo_magic()
	
	if not wfc.is_collapsed() and do_magic:
		ticks+=1
		wfc.iterate()
	else:
		do_magic = false
		init_button.disabled=false

func highlight_dots(wf_str:String):
	var wf_lines = wf_str.split("\n")
	var wf_lines_splitted = []
	for wf_line in wf_lines:
		var wf_splitted_line = []
		for wf_character in wf_line:
			wf_splitted_line.append(wf_character)
		wf_lines_splitted.append(wf_splitted_line)
	
	var highlighted_lines_splitted = wf_lines_splitted.duplicate()
	
	for dot_pos in dots:
		var wf_char = wf_lines[dot_pos.y][dot_pos.x]
		var highlighted_char = "[color=#"+DOT_COLOR.to_html(false)+"]"+wf_char+"[/color]"
		
		highlighted_lines_splitted[dot_pos.y][dot_pos.x] = highlighted_char
		
	var combined_highlighted = ""
	for line in highlighted_lines_splitted:
		var combined_line = ""
		
		for character in line:
			combined_line+=character
			
		combined_highlighted+=combined_line+"\n"
		
	return combined_highlighted

func redo_magic():
	dots=[]
	dot_counts=[0]
	init_button.disabled=true
	step_button.disabled=true
	ticks = 0
	wfc.initialize()
	do_magic = true

func _on_GenerateButton_pressed():
	redo_magic()

func _on_InitButton_pressed():
	asciidotsery.initialize(wfc.as_string())
	step_button.disabled=false

func _on_StepButton_pressed():
	asciidotsery.step()
	dots=asciidotsery.get_dots()
	dot_counts.append(len(dots))
