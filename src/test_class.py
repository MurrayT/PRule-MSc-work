#!/usr/bin/env python
import sys
import os
import json
import itertools
from permuta import *

sys.path.append(os.path.abspath("/Users/murraytannock/Documents/Programming/python/patterns/TheShading/the_shading_algorithm/"))

from tsa5_eq import tsa5_coincident

if __name__ == "__main__":
    filename = sys.argv[1]
    sys.stdout.write("Processing " + filename + "\n")
    sys.stdout.flush()

    patts = []
    with open(filename,"r") as f:
        for line in f.readlines():
            obj = json.loads(line)
            patt = MeshPattern(Permutation(obj["perm"]),map(tuple,obj["mesh"]))
            patts.append(patt)

    outfile = filename + ".out"
    if len(sys.argv) == 3:
        outfile = sys.argv[2]

    unexp = []
    for (p1, p2) in itertools.combinations(patts,2):
        if not tsa5_coincident(p1,p2,5):
            unexp.append((p1,p2))

    if len(unexp) > 0:
        with open(outfile,"w") as of:
            of.write("=======\n" + filename + "\n=======\n")
            for (p1,p2) in unexp:
                    of.write("-------\n")
                    of.write(repr(p1) + "\n")
                    of.write(repr(p2) + "\n\n")
                    of.write(str(p1) + "\n\n")
                    of.write(str(p2) + "\n")

