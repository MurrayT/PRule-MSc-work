import itertools
import sys
from permuta import *

def p_rule(mp,p=Permutation([2,3,1])):
    possibilities = []
    for box in itertools.product(range(len(mp)+1),range(len(mp)+1)):
        if not box in mp.mesh:
            thismp = mp.add_point(box)
            if thismp.perm == p:
                possibilities.append(mp.shade(box))
    return possibilities

def p_rule_checker(class0,class1,classlist,p=Permutation([2,3,1])):
    # we only need one between class p-rule coincidence
    for mp1 in classlist[class0]:
        prule = p_rule(mp1,p)
        for mpmod in prule:
            # print mpmod
            if mpmod in classlist[class1]:
                return mp1,mpmod
    else:
        sys.stderr.write("No Coincidences between class %d and %d\n" % (class0,class1))
        sys.stderr.flush()
        return None

def p_rule_check_base_class(class0,classlist,coincdict,p=Permutation([2,3,1])):
    instdict = {}
    for classi in coincdict[class0]:
        instdict[classi] = p_rule_checker(class0,classi,classlist,p)
    return instdict
