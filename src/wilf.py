from permuta import *
import pprint

class WilfCounter(object):

    def __init__(self, perm, mperm):
        self.perm = perm
        self.mperm= mperm
        self.record = {}

    def modify(self, checkperm):
        if checkperm.avoids(self.mperm):
            checklen = len(checkperm)
            self.record[checklen] = self.record.get(checklen,0) + 1

    def __repr__(self):
        return "WilfCounter(%s,%s)" % (self.perm, repr(self.mperm))

    def __str__(self):
        return pprint.pformat(self.record)

    def __eq__(self, other):
        if isinstance(other, WilfCounter):
            return self.record == other.record
        else:
            raise TypeError("Cannot compare WilfCounter with %s" % type(other))


def wilf_equivs231(classes,meshpd):
    wilf_equiv231 = set()
    for classn, thisclass in enumerate(classes):
        currset = frozenset(map(lambda x: meshpd[x.reverse().complement().inverse()], thisclass)) | frozenset(map(lambda x: meshpd[x],thisclass))
        if len(currset) > 1:
            wilf_equiv231.add(currset)
    return wilf_equiv231

def wilf_equivs321(classes,meshpd):
    wilf_equiv321 = set()
    for classn, thisclass in enumerate(classes):
        currset = (frozenset(map(lambda x: meshpd[x.reverse().complement().inverse()], thisclass)) |
                    frozenset(map(lambda x: meshpd[x],thisclass)) |
                    frozenset(map(lambda x: meshpd[x.reverse().complement()], thisclass)) |
                    frozenset(map(lambda x: meshpd[x.inverse()], thisclass)))
        if len(currset) > 1:
            wilf_equiv321.add(currset)
    return wilf_equiv321

def find_containing_set(setset, val):
    iset =  [aset for aset in setset if val in aset]
    if len(iset) == 1:
        return iset[0]
    else:
        return frozenset([val])

def resolve_prewilf_class(classnum, coincssets, wilfsets):
    to_resolve = set([classnum])
    fully_resolved = set()
    thisset = set()
    while len(to_resolve) > 0:
        currnum = to_resolve.pop()
        fully_resolved.add(currnum)
        currcoincs = find_containing_set(coincssets, currnum)
        currwilfs = find_containing_set(wilfsets,currnum)
        thisset = thisset | currcoincs | currwilfs
        to_resolve = thisset - fully_resolved
    return frozenset(thisset)

def resolve_all_prewilf_classes(coincsdict, wilfsets):
    coincssets = set(map(frozenset, coincsdict.values()))
    s = set()
    for classnum in range(220):
        s.add(resolve_prewilf_class(classnum, coincssets, wilfsets))
    return s

def get_wilf_sets(wilfcounts, wilfcounters, preequiv_12, preequiv_21, mp12, mp21):
    superset = set()
    for wilfseq in wilfcounts:
        thisset = frozenset()
        equivreprs = [x.mperm for x in wilfcounters if x.record == dict(enumerate(wilfseq))]
        ureprs = [x for x in equivreprs if x.perm.perm == [1,2]]
        dreprs = [x for x in equivreprs if x.perm.perm == [2,1]]
        ureprclasses = [(find_containing_set(preequiv_12, mp12[x]), '12') for x in ureprs]
        dreprclasses = [(find_containing_set(preequiv_21, mp21[x]), '21') for x in dreprs]
        thisset = thisset | frozenset(ureprclasses) | frozenset(dreprclasses)
        superset.add(thisset)
    return superset
