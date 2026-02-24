import io
import igraph
import sys

f = open(sys.argv[1], "r")
lines = f.readlines()
f.close()

a1 = {}
for line in lines:
    templist = line.strip().split(" ")
    if templist[1] not in a1:  # `has_key` yerine `not in` kullanıldı
        a1[templist[1]] = []
    a1[templist[1]].append(templist[2])

f = open(sys.argv[2], "r")
lines = f.readlines()
f.close()

a2 = {}
for line in lines:
    templist = line.strip().split(" ")
    if templist[1] not in a2:  # `has_key` yerine `not in` kullanıldı
        a2[templist[1]] = []
    a2[templist[1]].append(templist[2])

# Kalan kod aynı
match_type = []
for i in range(0, len(a1)):
    match_type.append(0)

for i in range(0, len(a2)):
    match_type.append(1)

edge_dict = {}
for temp1 in range(0, len(a1)):
    for temp2 in range(0, len(a2)):
        edge_dict[(temp1, temp2 + len(a1))] = len(set(a1[list(a1.keys())[temp1]]) & set(a2[list(a2.keys())[temp2]]))

g = igraph.Graph()
g.add_vertices(len(a1) + len(a2))
g.add_edges(edge_dict.keys())

matching = g.maximum_bipartite_matching(
    match_type, 
    list(edge_dict.values())  # `edge_dict.values()` listeye dönüştürüldü
)

removeA = []
moveAB = []
addB = []

for i in range(0, len(a1) + len(a2)):
    if i < len(a1):
        if matching.match_of(i) is None:
            removeA.append(i)
        else:
            moveAB.append((i, matching.match_of(i)))
    else:
        if matching.match_of(i) is None:
            addB.append(i)

mto = 0
for i in removeA:
    mto += len(a1[list(a1.keys())[i]])
    mto += 1

for i in addB:
    mto += len(a2[list(a2.keys())[i - len(a1)]])
    mto += 1

for temp in moveAB:
    mto += len(a1[list(a1.keys())[temp[0]]]) - edge_dict[temp] + len(a2[list(a2.keys())[temp[1] - len(a1)]]) - edge_dict[temp]

aco1 = sum(map(len, a1.values())) + len(a1)
aco2 = sum(map(len, a2.values())) + len(a2)

a2a = 1 - float(mto) / (float(aco1) + float(aco2))

print(a2a)

