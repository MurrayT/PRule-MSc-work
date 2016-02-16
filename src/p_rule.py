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

def p_rule_coincidences(meshpattdict,p=Permutation([2,3,1])):
    thiscoincdict = {k:[] for k in range(len(set(meshpattdict.values())))}
    mpperm = meshpattdict.keys()[0].perm
    for mp in MeshPatterns(len(meshpattdict.keys()[0].perm)):
        if mp.perm == mpperm:
            prule = p_rule(mp,p)
            for mpmod in prule:
                # print mp
                if meshpattdict[mpmod] not in thiscoincdict[meshpattdict[mp]]:
                    thiscoincdict[meshpattdict[mp]].append(meshpattdict[mpmod])
        else:
            continue

    coincdict_clean = {k:v for k,v in thiscoincdict.iteritems() if len(v)>0 }
    coincdict_clean2 = {k:frozenset(v+[k]) for k,v in coincdict_clean.iteritems()}
    superdict = {k:v for k,v in coincdict_clean2.iteritems() if len(v) > 1}

    for k in superdict:
        for j in superdict:
            if not superdict[k].isdisjoint(superdict[j]):
                superdict[k] = superdict[k] | superdict[j]

    return {k[0]:k for k in map(sorted,map(list,list(set(superdict.values()))))}

def funexplained(pcoincsdict, coincsdict):
    coincsets = map(frozenset,coincsdict.values())
    psets = map(frozenset,pcoincsdict.values())

    thisshets = {k:[v for v in psets if k>=v] for k in coincsets}

    return {sorted(list(k))[0]:(sorted(tuple(k)),map(sorted,map(tuple,v))) for k,v in thisshets.iteritems() if not all(b == k for b in v)}

def p_rule231(mp): # ASSUME 231 for now will fix later, maybe, now works for most basic
    possibilities = []
    p = Permutation([2,3,1])
    for (x,y) in mp.non_pointless_boxes(): # otherwise there are no points to slide
        if not (x,y) in mp.mesh:
            thismp = mp.add_increase((x,y))
            if thismp.perm.contains(p) and (x+1,y-1) not in mp.mesh:
                # we don't care about the box immediately right of box we're moving points from
                # or the one immediately below since we can't move points into there.
                v_boxes = [b for b in range(len(mp)+1) if b!=y and (x+1,b) in mp.mesh]
                if not all((x,b) in mp.mesh for b in v_boxes):
                    print "Cannot move vertical line"
                    continue # line is not free to move
                h_boxes = [a for a in range(len(mp)+1) if a!=x and (a,y-1) in mp.mesh]
                if all((b,y) in mp.mesh for b in h_boxes):
                    possibilities.append(mp.shade((x,y)))
                else:
                    print "Cannot move horizontal line"
    return possibilities

def p_rule231v2(mp, p = Permutation([2,3,1])): # ASSUME 231 for now will fix later, maybe, now works for most basic
    # we actually don't care about
    possibilities = []
    p = Permutation([2,3,1])
    for (x,y) in mp.non_pointless_boxes(): # otherwise there are no points to slide
        if not (x,y) in mp.mesh:
            thismp = mp.add_increase((x,y))
            if thismp.perm.contains(p) and (x+1,y-1) not in mp.mesh and (x,y) in enumerate(mp.perm):
                # we don't care about any boxes above and to the left of the point
                v_boxes = [b for b in range(y) if (x+1,b) in mp.mesh]
                if not all((x,b) in mp.mesh for b in v_boxes):
                    # print "Cannot move vertical line"
                    continue # line is not free to move
                h_boxes = [a for a in range(x+1, len(mp)+1) if (a,y-1) in mp.mesh]
                if all((b,y) in mp.mesh for b in h_boxes):
                    possibilities.append(mp.shade((x,y)))
    return possibilities

def can_pslide(pos,dx,dy,mp,perm):
    x,y = pos
    slidybox = (x+dx, y+dy)
    slidypoint = (x+-1*(dx<0),y+int(dy>0))
    # print (slidybox not in mp.mesh)
    # print slidypoint in enumerate(perm)
    # print list(enumerate(perm))
    # print slidypoint
    return (slidybox not in mp.mesh) and slidypoint in enumerate(mp.perm)

def can_vslide(pos, dx, dy, mp):
    x,y = pos
    if dy > 0:
        # we need to go from y+1 up
        vboxes = [b for b in range(y+1, len(mp)+1) if (x+dx,b) in mp.mesh]
    if dy < 0:
        # we need to go from 0 to y-1
        vboxes = [b for b in range(y) if (x+dx,b) in mp.mesh]
    return all((x,b) in mp.mesh for b in vboxes) # vertical line is free to slide

def can_hslide(pos, dx, dy, mp):
    x,y = pos
    if dx > 0:
        # we need to go from y+1 up
        hboxes = [b for b in range(x+1, len(mp)+1) if (b,y+dy) in mp.mesh]
    if dx < 0:
        # we need to go from 0 to y-1
        hboxes = [b for b in range(x) if (b,y+dy) in mp.mesh]
    return all((b,y) in mp.mesh for b in hboxes) # vertical line is free to slide

def can_allslide(pos,dx,dy,mp,perm):
    # print can_pslide(pos,dx,dy,mp,perm)
    # print can_vslide(pos, dx, dy, mp)
    # print can_hslide(pos, dx, dy, mp)
    return can_pslide(pos,dx,dy,mp,perm) and can_vslide(pos, dx, dy, mp) and can_hslide(pos, dx, dy, mp)

def p_rule2(mp, p = Permutation([2,3,1])): # should be generic now.
    possibilities = []
    for box in mp.non_pointless_boxes(): # otherwise there are no points to slide
        if not box in mp.mesh: # otherwise we can't choose a point in this box
            thismp = mp.add_increase(box)
            if thismp.perm.contains(p): # we can only have a decrease in this box
                # print "only decrease"
                if can_allslide(box,1,-1,mp,p):
                    # This checks to see if we can slide the points SE
                    possibilities.append(mp.shade(box))
                if can_allslide(box,-1,1,mp,p):
                    # This checks to see if we can slide the points NW
                    possibilities.append(mp.shade(box))
            thismp = mp.add_decrease(box)
            if thismp.perm.contains(p): # we can only have an increase in this box
                # print "only increase"
                if can_allslide(box,-1,-1,mp,p):
                    # This checks to see if we can slide the points SW
                    possibilities.append(mp.shade(box))
                if can_allslide(box,-1,-1,mp,p):
                    # This checks to see if we can slide the points NE
                    possibilities.append(mp.shade(box))
    return possibilities

def p_2_rule_checker(class0,class1,classlist,p=Permutation([2,3,1])):
    # we only need one between class p-rule coincidence
    for mp1 in classlist[class0]:
        prule = p_rule231v2(mp1,p)
        for mpmod in prule:
            # print mpmod
            if mpmod in classlist[class1]:
                return mp1,mpmod
    for mp1 in classlist[class1]:
        prule = p_rule231v2(mp1,p)
        for mpmod in prule:
            # print mpmod
            if mpmod in classlist[class0]:
                sys.stderr.write("FOUND: Coincidences between class %d and %d\n" % (class0,class1))
                sys.stderr.flush()
                return mp1,mpmod
    else:
        sys.stderr.write("No Coincidences between class %d and %d\n" % (class0,class1))
        sys.stderr.flush()
        return None

def p_2_rule_coincidences(meshpattdict,p=Permutation([2,3,1]),method=p_rule2):
    thiscoincdict = {k:[] for k in range(len(set(meshpattdict.values())))}
    mpperm = meshpattdict.keys()[0].perm
    for mp in MeshPatterns(2):
        if mp.perm == mpperm:
            prule = method(mp,p)
            for mpmod in prule:
                # print mp
                if meshpattdict[mpmod] not in thiscoincdict[meshpattdict[mp]]:
                    thiscoincdict[meshpattdict[mp]].append(meshpattdict[mpmod])
        else:
            continue

    coincdict_clean = {k:v for k,v in thiscoincdict.iteritems() if len(v)>0 }
    coincdict_clean2 = {k:frozenset(v+[k]) for k,v in coincdict_clean.iteritems()}
    superdict = {k:v for k,v in coincdict_clean2.iteritems() if len(v) > 1}

    for k in superdict:
        for j in superdict:
            if not superdict[k].isdisjoint(superdict[j]):
                superdict[k] = superdict[k] | superdict[j]

    return {k[0]:k for k in map(sorted,map(list,list(set(superdict.values()))))}

def resolve_class(classnum, funexplaineddict ,p2_coincdict):
    classb = funexplaineddict[classnum]
    connections = filter(lambda x:len(x) > 1,[p2_coincdict.get(x,[]) for x in classb[0]])
    littlesets = set(map(frozenset, classb[1]))
    for connect in connections:
        for connect1,connect2 in itertools.combinations(connect,2):
            set1 = filter(lambda x: connect1 in x,littlesets)[0]
            set2 = filter(lambda y: connect2 in y,littlesets)[0]
            littlesets.discard(set1)
            littlesets.discard(set2)
            littlesets.add(set1 | set2)
            if len(littlesets) == 1:
                break
    return littlesets

def resolve_fundict(funexplaineddict, p2_coincdict):
    newdict = {k:[v[0]] for k,v in funexplaineddict.iteritems()}
    for classnum in funexplaineddict:
        newdict[classnum].append(resolve_class(classnum, funexplaineddict, p2_coincdict))
    sdict = {k:v for k,v in newdict.iteritems() if len(v[1])> 1}
    return {k:(v[0],list(map(list,v[1]))) for k,v in sdict.iteritems()}
