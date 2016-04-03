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
