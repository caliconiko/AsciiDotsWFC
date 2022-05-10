from godot import exposed, Control, ProjectSettings, Vector2, Array

from dots.callbacks import IOCallbacksStorage
from dots.environment import Env
from dots.interpreter import AsciiDotsInterpreter

from time import sleep
import copy

class Callbacks(IOCallbacksStorage):
	def __init__(self, env):
		self.outputs = []
		self.env = env
		self.env.io = self
		self.running = False
		self.dots = None
		
	def get_input(self, ascii_char=False):
		return 65
		
	def on_output(self, value):
		self.outputs.append(value)

	def on_finish(self):
		pass
		
	def on_error(self, error_text):
		print(error_text)
		
	def on_microtick(self, dot):
		self.dots=self.env.dots
		
		if(self.running==True):
			self.running = False
		while self.running == False:
			sleep(0.0001)
		pass
		
	def get_dots(self):
		return copy.deepcopy(self.env.dots)

@exposed
class AsciiDotsery(Control):

	interpreter:AsciiDotsInterpreter = None
	callbacks:Callbacks = None
	
	def _ready(self):
		pass
		
	def initialize(self, program):
		program_str = str(program)
		program_dir = ProjectSettings.globalize_path("res://")

		env = Env()
		self.callbacks = Callbacks(env)

		self.interpreter = AsciiDotsInterpreter(env, program_str, program_dir, True)
		self.interpreter.run(run_in_separate_thread=True)

	def step(self):
		self.interpreter.env.io.running = True

	def get_dots(self):
		dots = self.interpreter.env.dots
		converted_dots = Array([Vector2(dot.pos.x, dot.pos.y) for dot in dots])
		
		return converted_dots
		
	def get_outputs(self):
		outputs = self.callbacks.outputs
		return Array(outputs)
