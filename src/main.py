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

# need to prune by symmetries
#
reprs231 = [classes[x[0]][0] for x in coincsdict231_12.values()] + [classes[x[0]][0] for x in coincsdict231_21.values()]
reprs321 = [classes[x[0]][0] for x in coincsdict321_21.values()] #+ [classes[x[0]][0] for x in coincsdict321_12.values()]

wilf231 = [WilfCounter(Permutation([2,3,1]),x ) for x in reprs231]
wilf321 = [WilfCounter(Permutation([3,2,1]),x ) for x in reprs321]
