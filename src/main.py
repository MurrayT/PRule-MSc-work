from permuta import MeshPattern
import sys
from classes import *
from helper_funcs import *
from p_rule import *
from wilf import *

def stderrwrite(string,end="\n"):
    sys.stderr.write(string+end)
    sys.stderr.flush()

classes2 = [map(MeshPattern.reverse, x) for x in classes]
stderrwrite("Classes created")

p_231 = Permutation([2,3,1])
p_321 = Permutation([3,2,1])

reprs_12 = get_representatives(classes)
reprs_21 = get_representatives(classes2)
stderrwrite("Representatives created")

meshpd_12 = mpdict(classes)
meshpd_21 = mpdict(classes2)

stderrwrite("Computing Coincidences 1 of 4")
coincs231_12 = get_coincidences(reprs_12, 8, p_231)
stderrwrite("Computing Coincidences 2 of 4")
coincs321_12 = get_coincidences(reprs_12, 8, p_321)
stderrwrite("Computing Coincidences 3 of 4")
coincs231_21 = get_coincidences(reprs_21, 8, p_231)
stderrwrite("Computing Coincidences 4 of 4")
coincs321_21 = get_coincidences(reprs_21, 8, p_321)
stderrwrite("Coincidences done")

coincsdict231_12 = coincidences_to_dictionary(coincs231_12)
coincsdict321_12 = coincidences_to_dictionary(coincs321_12)
coincsdict231_21 = coincidences_to_dictionary(coincs231_21)
coincsdict321_21 = coincidences_to_dictionary(coincs321_21)

p_coincs231_12 = p_rule_coincidences(meshpd_12, p_231)
p_coincs321_12 = p_rule_coincidences(meshpd_12, p_321)
p_coincs231_21 = p_rule_coincidences(meshpd_21, p_231)
p_coincs321_21 = p_rule_coincidences(meshpd_21, p_321)

p2_coincs231_12 = p_2_rule_coincidences(meshpd_12, p_231)
p2_coincs321_12 = p_2_rule_coincidences(meshpd_12, p_321)
p2_coincs231_21 = p_2_rule_coincidences(meshpd_21, p_231)
p2_coincs321_21 = p_2_rule_coincidences(meshpd_21, p_321)

unexplained231_12 = funexplained(p_coincs231_12, coincsdict231_12)
unexplained321_12 = funexplained(p_coincs321_12, coincsdict321_12)
unexplained231_21 = funexplained(p_coincs231_21, coincsdict231_21)
unexplained321_21 = funexplained(p_coincs321_21, coincsdict321_21)

resolved231_12 = resolve_fundict(unexplained231_12, p2_coincs231_12)
resolved321_12 = resolve_fundict(unexplained321_12, p2_coincs321_12)
resolved231_21 = resolve_fundict(unexplained231_21, p2_coincs231_21)
resolved321_21 = resolve_fundict(unexplained321_21, p2_coincs321_21)

wilf_equivs231_12 = wilf_equivs231(classes, meshpd_12)
wilf_equivs321_12 = wilf_equivs321(classes, meshpd_12)
wilf_equivs231_21 = wilf_equivs231(classes2, meshpd_21)
wilf_equivs321_21 = wilf_equivs321(classes2, meshpd_21)

pre_test_wilf231_12 = resolve_all_prewilf_classes(coincsdict231_12, wilf_equivs231_12)
pre_test_wilf321_12 = resolve_all_prewilf_classes(coincsdict321_12, wilf_equivs321_12)
pre_test_wilf231_21 = resolve_all_prewilf_classes(coincsdict231_21, wilf_equivs231_21)
pre_test_wilf321_21 = resolve_all_prewilf_classes(coincsdict321_21, wilf_equivs321_21)

wreprs231_12 = [sorted(classes[sorted(list(x))[0]])[0] for x in pre_test_wilf231_12]
wreprs321_12 = [sorted(classes[sorted(list(x))[0]])[0] for x in pre_test_wilf321_12]
wreprs231_21 = [sorted(classes2[sorted(list(x))[0]])[0] for x in pre_test_wilf231_21]
wreprs321_21 = [sorted(classes2[sorted(list(x))[0]])[0] for x in pre_test_wilf321_21]

wreprs231 = set(wreprs231_12 + wreprs231_21)
wreprs321 = set(wreprs321_12 + wreprs321_21)

wilfcounters231 = [WilfCounter(Permutation([2,3,1]), mperm) for mperm in wreprs231]
wilfcounters321 = [WilfCounter(Permutation([3,2,1]), mperm) for mperm in wreprs321]

for permlen in range(11):
    for perm in PermutationsAvoiding231(permlen):
        for counter in wilfcounters231:
            counter.modify(perm)
    for perm in PermutationsAvoiding321(permlen):
        for counter in wilfcounters321:
            counter.modify(perm)
    stderrwrite("Length %d complete" % permlen)

wilfcounts231 = list(set([tuple(counter.record.values()) for counter in wilfcounters231]))
wilfcounts321 = list(set([tuple(counter.record.values()) for counter in wilfcounters321]))


wilf_equivs231 = get_wilf_sets(wilfcounts231, wilfcounters231,
                               pre_test_wilf231_12, pre_test_wilf231_21,
                               meshpd_12, meshpd_21)
wilf_equivs321 = get_wilf_sets(wilfcounts321, wilfcounters321,
                               pre_test_wilf321_12, pre_test_wilf321_21,
                               meshpd_12, meshpd_21)
