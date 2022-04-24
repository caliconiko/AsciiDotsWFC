extends Control



#COLORS = {
#    REGULAR: (248, 248, 242),
#    DOT: (104, 113, 94),
#    BACKGROUND: (39, 40, 34),
#    OPERATOR: (253, 151, 31),
#    BRACKETS: (104, 113, 94),
#    CONTROL_FLOW: (248, 37, 92),
#    CONTROL_DIR: (102, 217, 239),
#    DIGIT: (174, 129, 255),
#    WRAP: (230, 219, 93),
#    LIBVRAP: (166, 226, 46),
#    ESCAPE_SEQUANCES: (249, 38, 114),
#    MODES: (166, 226, 46),
#    MSG: (248, 248, 242),
#    MSG_BG: (62, 61, 50),
#    MOREDEBUG_COLOR: (253, 151, 31),
#}
var BACKGROUND_COLOR = Color(0.152941, 0.156863, 0.133333)

func _ready():
	VisualServer.set_default_clear_color(BACKGROUND_COLOR)
	
