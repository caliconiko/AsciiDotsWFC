import json
import numpy as np
"""
Ignore this script lol
"""
module_data_file_name = "full_module_data.json"

# read file into text
with open(module_data_file_name, "r") as f:
    module_data_text = f.read()

# parse json
module_data = json.loads(module_data_text)
print(module_data)

class WFC:
    def __init__(self, size, module_data):
        self.size = size
        self.module_data = module_data