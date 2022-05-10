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
SELF_CONNECTING = "self_connecting"

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

WEIGHT = "weight"

def rotate_sockets_clockwise(sockets):
    new_sockets = deepcopy(sockets)
    for dir in sockets:
        new_sockets[rotate_dir_clockwise[dir]] = sockets[dir]
    return new_sockets

rotated_module_data = {}

for m in basic_module_data:
    module = m
    m_data:dict = basic_module_data[module]
    module_data = deepcopy(m_data)

    sockets = module_data[SOCKETS]

    should_rotate_sockets = False
    if ROTATE_SOCKETS in module_data:
        should_rotate_sockets = module_data[ROTATE_SOCKETS]

    iterations = 1
    if should_rotate_sockets:
        iterations = 4

    for i in range(iterations):
        if should_rotate_sockets:
            module = m+"r"+str(i)
            module_data[WEIGHT] = m_data[WEIGHT]/4

        module_data[SOCKETS] = sockets
        rotated_module_data[module] = deepcopy(module_data)

        sockets = rotate_sockets_clockwise(sockets)

full_module_data = {}

def is_self_connecting(module, other_module):
    rotated = "r" in module 
    if rotated:
        return module[0]==other_module[0] and "r" in other_module
    else:
        return module in other_module or other_module in module

# do thing
for m in rotated_module_data:
    module=m
    module_data:dict = rotated_module_data[module]

    sockets = module_data[SOCKETS]

    module_self_connecting = True
    if SELF_CONNECTING in module_data:
        module_self_connecting = module_data[SELF_CONNECTING]


    possible_neighbours = defaultdict(list)
    for other_module in rotated_module_data:
        check_self_connection = False
        if not module_self_connecting:
            check_self_connection = is_self_connecting(module, other_module)

        other_module_data:dict = rotated_module_data[other_module]

        other_sockets = other_module_data[SOCKETS]

        for dir in dirs:
            other_dir = invert_dir[dir]

            if sockets[dir] == other_sockets[other_dir] and not check_self_connection:
                possible_neighbours[dir].append(other_module)

    full_module_data[module] = module_data
    full_module_data[module]["possible_neighbours"] = dict(possible_neighbours)

# write thing
json_dumps = json.dumps(full_module_data, indent=4)

output_file_name = "full_module_data.json"
with open(output_file_name, "w") as f:
    f.write(json_dumps)
