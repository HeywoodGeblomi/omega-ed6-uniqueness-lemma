import json, re, hashlib, os
here = os.path.dirname(os.path.abspath(__file__))
d = open(os.path.join(here, "..", "data", "kz_along_A.json"), "rb").read()
h = hashlib.sha256(d).hexdigest()
assert h == "06e6a20f0bdd14dc6c31fc1a174aa09c1286abd1fa0f2bee2dd6ed19e740a50e", h
j = json.loads(d)
src = open(os.path.join(here, "AToRatio.lean")).read()
def lit(name):
    m = re.search(r"def " + name + r" : List \(List Int\) := (\[.*\])", src)
    return json.loads(m.group(1))
assert lit("A") == j["A"], "A mismatch"
assert lit("Mplus") == j["M_plus"], "M_plus mismatch"
print("OK", h, "A and M_plus literals match the pinned JSON")
