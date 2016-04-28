f = sys.stdout
with open("classes.tex", "w") as f:
    f.write("\\chapter{Equivalence classes of mesh patterns}\n")
    f.write("\\section{Equivalence classes with classical pattern 12}\n")
    f.write("\\begin{center}")
    for classnum,thisclass in enumerate(classes):
        f.write("\\begin{equation}\n\t\\begin{gathered}\n")
        for index, texstr in enumerate(map(meshpatt_to_tex, thisclass)):
            f.write("\t\t")
            f.write(texstr)
            if index % 10 == 9:
                f.write("\\\\")
            f.write("\n")
        f.write("\t\\end{{gathered}}\n\t\\label{{cls:{}}}\n\end{{equation}}\n\n".format(classnum))
    f.write("\\end{center}")

sorted(map(list,sorted(map(reversed, (pad_sequence(9,x) for x in  wilfcounts231)))))

write_to_clipboard(("\n".join((("{:5d},"*9).format(*reversed(seq)))[:-1] for seq in sorted(map(list,sorted(map(reversed, (pad_sequence(9,x) for x in  wilfcounts231))))))))

write_to_clipboard(("\\\n".join((("{:5d},"*11 + " \&\t\& {classize}").format(*x[0],classize=x[1])) for x in f )))

def number_of_patts(seq, wilfcounters, mpdu, mpdd,  setup, setdown, uclasses, dclasses):
    wilfreps = [f.mperm for f in filter(lambda x: x.record == dict(enumerate(a)), wilfcounters)]
    uperms = filter(lambda x: x.perm == Permutation([1,2]), wilfreps)
    dperms = filter(lambda x: x.perm == Permutation([2,1]), wilfreps)
    ucl = [mpdu[x] for x in uperms]
    dcl = [mpdd[x] for x in dperms]
    if len(ucl) >0:
        ucls = frozenset.union(*(find_containing_set(setup, num) for num in ucl))
        usum = sum(len(uclasses[l]) for l in ucls)
    else: usum = 0
    if len(dcl) > 0:
        dcls = frozenset.union(*(find_containing_set(setdown, num) for num in dcl))
        dsum = sum(len(dclasses[l]) for l in dcls)
    else:dsum = 0
    return usum + dsum

import subprocess

def write_to_clipboard(output):
    process = subprocess.Popen(
        'pbcopy', env={'LANG': 'en_US.UTF-8'}, stdin=subprocess.PIPE)
    process.communicate(output.encode('utf-8'))

number_of_patts(a, wilfcounters321, meshpd_12, meshpd_21, pre_test_wilf321_12, pre_test_wilf321_21, classes, classes2)

def patts_with_sequence(seq, wilfcounters, mpdu, mpdd,  setup, setdown, uclasses, dclasses):
    wilfreps = [f.mperm for f in filter(lambda x: x.record == dict(enumerate(a)), wilfcounters)]
    uperms = filter(lambda x: x.perm == Permutation([1,2]), wilfreps)
    dperms = filter(lambda x: x.perm == Permutation([2,1]), wilfreps)
    ucl = [mpdu[x] for x in uperms]
    dcl = [mpdd[x] for x in dperms]
    if len(ucl) >0:
        ucls = frozenset.union(*(find_containing_set(setup, num) for num in ucl))
    else:ucls=frozenset()
    if len(dcl) > 0:
        dcls = frozenset.union(*(find_containing_set(setdown, num) for num in dcl))
    else:dcls=frozenset()
    return [list(ucls),list(dcls)]
