from igraph import *
import random
import numpy as np
import matplotlib.pyplot as plt


def simulation(g, n, m, b, a):
    """
    SIR Model simulation with availability
    :param g: graph
    :param n: size of initial infection
    :param m: probability of recovery
    :param b: probability of infection
    :param a: availability
    :return: list of graphs in each step, array of S, I, R counts
    """
    g.vs["state"] = "S"
    g.vs["color"] = "orange"
    g.vs["size"] = 50

    seeding(g, n=n)
    update_colors(g)

    g_history = [deepcopy(g)]
    counts = [count_states(g)]
    flag = True
    while flag:
        set_availability(g, a=a)
        infection(g, b=b)
        recovery(g, m=m)
        update_colors(g)
        s_count, i_count, r_count = count_states(g)
        counts.append((s_count, i_count, r_count))
        flag = i_count != 0
        g_history.append(deepcopy(g))

    return g_history, np.array(counts)


def seeding(g, n):
    indexes = g.vs.indices
    indexes_to_infect = random.sample(indexes, n)
    g.vs[indexes_to_infect]["state"] = "I"
    print(g.vs[indexes_to_infect])


def set_availability(g, a):
    for vertex in g.vs:
        if np.random.random() < a:
            vertex["availability"] = True
        else:
            vertex["availability"] = False


def update_colors(g):
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    g.vs[infected_indexes]["color"] = "red"
    recovered_indexes = list(np.where(np.array(g.vs["state"]) == "R")[0])
    g.vs[recovered_indexes]["color"] = "green"


def infection(g, b):
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    for i in infected_indexes:
        if g.vs["availability"]:
            neighbors = g.neighbors(g.vs[i])
            for neighbor in neighbors:
                if g.vs[neighbor]["state"] == "S" and g.vs[neighbor]["availability"]:
                    if np.random.rand() < b:
                        g.vs[neighbor]["state"] = "I"


def recovery(g, m):
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    for i in infected_indexes:
        if np.random.rand() < m:
            g.vs[i]["state"] = "R"


def count_states(g):
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    recovered_indexes = list(np.where(np.array(g.vs["state"]) == "R")[0])
    susceptible_indexes = list(np.where(np.array(g.vs["state"]) == "S")[0])
    return len(susceptible_indexes), len(infected_indexes), len(recovered_indexes)


def main():
    a_values = [1, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1, 0.0]
    fig, axes = plt.subplots(4, 2)
    g = Graph.Watts_Strogatz(dim=1, size=1000, nei=3, p=0.8)

    for idx, a in enumerate(a_values):
        ax = axes.flat[idx]
        g_history, counts = simulation(g, n=5, m=0.05, b=0.2, a=a)
        ax.plot(counts[:, 0], label="Susceptible", c="orange")
        ax.plot(counts[:, 1], label="Infected", c="red")
        ax.plot(counts[:, 2], label="Recovered", c="green")
        ax.set_title(f'Dostępnosć = {a}')
        ax.legend()

    plt.tight_layout()
    plt.show()

    # for g in g_history:
    #     plot(g)


if __name__ == "__main__":
    main()
