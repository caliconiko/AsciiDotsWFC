import json
from collections import defaultdict
from copy import deepcopy

basic_data_file_name = "basic_module_data.json"

# read file into text
with open(basic_data_file_name, "r") as f:
    basic_data_text = f.read()

# parse json
basic_module_data = json.loads(basic_data_text)

UP = "up"
DOWN = "down"
LEFT = "left"
RIGHT = "right"

SOCKETS = "sockets"
ROTATE_SOCKETS = "rotate_sockets"

dirs = [UP, DOWN, LEFT, RIGHT]

invert_dir = {
    UP: DOWN,
    DOWN: UP,
    LEFT: RIGHT,
    RIGHT: LEFT,
}

rotate_dir_clockwise = {
    UP:RIGHT,
    RIGHT:DOWN,
    DOWN:LEFT,
    LEFT:UP,
}

full_module_data = {}

def rotate_sockets_clockwise(sockets):
    new_sockets = deepcopy(sockets)
    for dir in sockets:
        new_sockets[rotate_dir_clockwise[dir]] = sockets[dir]
    return new_sockets


# do thing
for m in basic_module_data:
    module=m
    module_data:dict = basic_module_data[module]

    sockets = module_data[SOCKETS]

    possible_neighbours = defaultdict(list)
    for other_module in basic_module_data:
        other_module_data:dict = basic_module_data[other_module]

        other_sockets = other_module_data[SOCKETS]

        for dir in dirs:
            other_dir = invert_dir[dir]

            if sockets[dir] == other_sockets[other_dir]:
                possible_neighbours[dir].append(other_module)

    full_module_data[module] = module_data
    full_module_data[module]["possible_neighbours"] = dict(possible_neighbours)

# write thing
json_dumps = json.dumps(full_module_data, indent=4)

output_file_name = "full_module_data.json"
with open(output_file_name, "w") as f:
    f.write(json_dumps)
