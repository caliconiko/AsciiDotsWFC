import json
from collections import defaultdict
from copy import deepcopy

basic_data_file_name = "basic_module_data.json"

# read file into text
with open(basic_data_file_name, "r") as f:
    basic_data_text = f.read()

# parse json
basic_module_data = json.loads(basic_data_text)

SOCKETS = "sockets"
IN_SOCKETS = "in_sockets"
OUT_SOCKETS = "out_sockets"

invert_dir = {
    "up": "down",
    "down": "up",
    "left": "right",
    "right": "left",
}

dirs = ["up", "down", "left", "right"]

full_module_data = deepcopy(basic_module_data)

# do thing
for module in basic_module_data:
    module_data:dict = basic_module_data[module]

    in_sockets:dict = None
    out_sockets:dict = None

    if SOCKETS in module_data.keys():
        in_sockets = module_data[SOCKETS]
        out_sockets = module_data[SOCKETS]
    else:
        in_sockets = module_data[IN_SOCKETS]
        out_sockets = module_data[OUT_SOCKETS]

    possible_neighbours = defaultdict(list)

    for other_module in basic_module_data:
        other_module_data:dict = basic_module_data[other_module]

        other_in_sockets:dict = None
        other_out_sockets:dict = None

        if SOCKETS in other_module_data.keys():
            other_in_sockets = other_module_data[SOCKETS]
            other_out_sockets = other_module_data[SOCKETS]
        else:
            other_in_sockets = other_module_data[IN_SOCKETS]
            other_out_sockets = other_module_data[OUT_SOCKETS]

        for dir in dirs:
            other_dir = invert_dir[dir]

            if out_sockets[dir] == other_in_sockets[other_dir]:
                possible_neighbours[dir].append(other_module)
    
    full_module_data[module]["possible_neighbours"] = dict(possible_neighbours)

# write thing
json_dumps = json.dumps(full_module_data, indent=4)

output_file_name = "full_module_data.json"
with open(output_file_name, "w") as f:
    f.write(json_dumps)
