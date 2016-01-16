import json
from permuta import *

def load_set(filename):
    patts = []
    with open(filename,'r') as f:
        for line in f.readlines():
            obj = json.loads(line)
            pattern = MeshPattern(Permutation(obj["perm"]),map(tuple,obj["mesh"]))
            patts.append(pattern)
    return patts

