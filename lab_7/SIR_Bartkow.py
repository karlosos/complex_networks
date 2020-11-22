from igraph import *
import random
# import matplotlib.pyplot as plt

def zasiewanko(e, f):

    axes = []

    w1 = 0
    while w1 < e:
        ax = random.choice(f)
        if ax not in axes:
            g.vs[ax]["infected"] = 1
            g.vs[ax]["immunity"] = 1
            g.vs[ax]["inf_by"] = 'seed'
            axes.append(ax)
            w1 += 1

def zarazanko(aa, bb, c):

    x_1 = round((random.uniform(0, 1)), 2)
    g.vs[bb]["attacks"] += 1

    if x_1 <= pp:

        g.vs[aa]["stepinfected"] = c
        g.vs[aa]["infected"] = 1
        g.vs[aa]["immunity"] = 1
        g.vs[bb]["inf_nei"] += 1
        g.vs[aa]["inf_by"] = g.vs[bb]["name"]

        # print("! ZARAZONO !", a)

    elif x_1 > pp:

        g.vs[aa]["step_att"] += 1
        g.vs[aa]["attempts"] += 1
        g.vs[aa]["last_con_s"] = c

        # print("kontakt :", g.vs[aa]["name"], g.vs[aa]["contacts"])

# net = open("test_16.txt", 'r')
g = Graph.Read_Ncol('../data/facebook_combined.txt', directed=False)
vs = VertexSeq(g)

nodes = Graph.vcount(g)
edg = Graph.ecount(g)

print(nodes, edg)
# print(g)
# layout = g.layout("kk")

deg = []

for i in range(0, nodes):

    neighborstab = g.neighbors(i, mode="out")
    node = {'name': i, 'degree': len(neighborstab)}
    deg.append(node)
    g.vs[i]["name"] = i
    g.vs[i]["stepinfected"] = 0
    g.vs[i]["infected"] = 0
    g.vs[i]["immunity"] = 0
    g.vs[i]["degree"] = len(neighborstab)
    g.vs[i]["step_att"] = 0
    g.vs[i]["attempts"] = 0
    g.vs[i]["inf_nei"] = 0
    g.vs[i]["inf_by"] = 0
    g.vs[i]["inf_dur"] = 0
    g.vs[i]["last_con_s"] = 0
    g.vs[i]["attacks"] = 0
    # print(g.vs[i])

pp_list = [0.1]
rec_list = [0.1]
see1_list = [1]

for pp in pp_list:
    # print(pp)
    for rec in rec_list:
        # print(rec)
        for se1 in see1_list:
            ws1 = round((se1 / 100) * nodes)
            see1 = ws1
            # print(see1)
            loop = 1

            while loop <= 10:

                zasiewanko(ws1, nodes)

                isInfecting = True

                s = 0
                r = 0
                att = 0
                att_nodes = []
                infected = 0

                while isInfecting:

                    spreaders = []

                    s += 1
                    # print(s)
                    INF = 0

                    for j in range(0, nodes):

                        if g.vs[j]["infected"] == 1:
                            spreaders.append(j)

                    # print(spreaders)
                    random.shuffle(spreaders)

                    for j in spreaders:

                        # print("zarazajacy:", j)

                        neighborstab = g.neighbors(j, mode="out")

                        if len(neighborstab) > 0:

                            # n = 0
                            notinfected = []

                            for i in neighborstab:

                                # print(i)

                                if g.vs[i]["immunity"] == 0:
                                    notinfected.append(i)

                            # print(neighborstab)
                            # print(notinfected)

                            if notinfected:

                                for k in notinfected:
                                    zarazanko(k, j, s)

'''
visual_style = {}
visual_style["vertex_size"] = 20
visual_style["vertex_label"] = g.vs["name"]
visual_style["edge_width"] = [1]
visual_style["layout"] = layout
visual_style["bbox"] = (700, 700)
visual_style["margin"] = 20
plot(g, **visual_style)
'''