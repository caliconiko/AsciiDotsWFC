extends Control

onready var text_box = $HBoxContainer/RichTextLabel
onready var ticks_label = $HBoxContainer/VBoxContainer/Ticks
onready var asciidots_ticks_label = $HBoxContainer/VBoxContainer/AsciiDotsTicks
onready var dot_count_label = $HBoxContainer/VBoxContainer/DotCount
onready var asciidotsery = $AsciiDotsery

onready var init_button = $HBoxContainer/VBoxContainer/InitButton
onready var step_button = $HBoxContainer/VBoxContainer/StepButton
onready var run_button = $HBoxContainer/VBoxContainer/HBoxContainer/RunButton
onready var stop_button = $HBoxContainer/VBoxContainer/HBoxContainer/StopButton

onready var run_timer = $RunTimer

onready var interpreter_buttons = [step_button, run_button, stop_button]

var ticks = 0

var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)
var DOT_COLOR = Color(0.976471, 0.14902, 0.447059)
var wfc

var do_magic = false
var interpreting = false

var dots = []
var asciidot_ticks = 0
var dot_count = -1

var wave_function_string = ""

export(int,0,90) var wave_function_width = 90
export(int,0,25) var wave_function_height = 25

func _ready():
	randomize()
	
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	dot_count_label.modulate = DOT_COLOR
	
	wfc = WFC.new(Vector2(wave_function_width,wave_function_height),Global.module_data)

func _process(_delta):
	if do_magic:
		wave_function_string = wfc.as_string()
		text_box.bbcode_text = highlight_dots(wave_function_string)
	else:
		text_box.bbcode_text = highlight_dots(wave_function_string)
	ticks_label.text = str(ticks)
	asciidots_ticks_label.text = str(asciidot_ticks)
	dot_count_label.text = str(dot_count)
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
		var dot_pos_below_zero = dot_pos.x<0 or dot_pos.y<0

		if dot_pos_below_zero:
			interpreting=false
			return ""
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
	interpreting=false
	dots=[]
	dot_count = -1
	asciidot_ticks = 0
	ticks = 0
	
	init_button.disabled=true
	for button in interpreter_buttons:
		button.disabled = true
		
	wfc.initialize()
	do_magic = true

func step_interpreter():
	asciidotsery.step()
	dots=asciidotsery.get_dots()
	dot_count=len(dots)
	asciidot_ticks+=1

func _on_GenerateButton_pressed():
	redo_magic()

func _on_InitButton_pressed():
	dots=[]
	dot_count = -1
	asciidot_ticks = 0
	asciidotsery.initialize(wave_function_string)
	for button in interpreter_buttons:
		button.disabled = false
	
func _on_StepButton_pressed():
	step_interpreter()

func _on_RunButton_pressed():
	interpreting=true
	run_timer.start()

func _on_RunTimer_timeout():
	var dot_count_good = dot_count<0 or dot_count>0
	if interpreting and dot_count<1000 and dot_count_good:
		step_interpreter()
		run_timer.start()
	else:
		interpreting = false
	
func _on_StopButton_pressed():
	interpreting=false


