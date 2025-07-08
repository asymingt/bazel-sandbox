from python.runfiles import Runfiles

r = Runfiles.Create()
p = r.Rlocation("experimental/data/foo.txt")
print("Found data file path: ", p)
with open(p, "r") as f:
    print(f.read())