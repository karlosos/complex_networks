"""
Wykorzastanie sieci WS i BA złożonych z około 500-1000 węzłów z porównywalnym średnim degree.

Zbadać wypływu usunięcia losowego 5%, 10%, 20% węzłów na zasięg procesu propagacji.

Usunięcie może być reprezentowane przez wprowadzenie dodatkowego attrybutu dla węzła.

Propagacja symulowana na podstawie dowolnego z wcześniejszych modeli z ustalonymi parametrami propagacji, taką samą liczbą seedów.
Przykładowo transmission rate 0.1 i seeding 5% dla wszystkich procesów.

Efektem są dwa wykresy z przebiegami procesów na każdym efekty dla sieci kompletnej i po usunięciu 5%, 10%, 20% węzłów.
"""

from igraph import *
import random
import numpy as np
import matplotlib.pyplot as plt


def simulation(g, n, m, b, limitation):
    """
    SIR Model simulation
    :param g: graph
    :param n: size of initial infection
    :param m: probability of recovery
    :param b: probability of infection
    :param limitation: how many nodes are unavaiable (as a fraction)
    :return: list of graphs in each step, array of S, I, R counts
    """
    g.vs["state"] = "S"
    g.vs["color"] = "orange"
    g.vs["size"] = 50
    g.vs["availability"] = True

    seeding(g, n=n)
    set_availability(g, limitation)

    update_colors(g)

    g_history = [deepcopy(g)]
    counts = [count_states(g)]
    flag = True
    while flag:
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


def set_availability(g, limitation):
    indexes = g.vs.indices
    n = int(len(indexes) * limitation)
    indexes_to_disable = random.sample(indexes, n)
    g.vs[indexes_to_disable]["availability"] = False
    print(g.vs[indexes_to_disable])


def update_colors(g):
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    g.vs[infected_indexes]["color"] = "red"
    recovered_indexes = list(np.where(np.array(g.vs["state"]) == "R")[0])
    g.vs[recovered_indexes]["color"] = "green"
    recovered_indexes = list(np.where(np.array(g.vs["availability"]) == False)[0])
    g.vs[recovered_indexes]["color"] = "blue"


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
    g = Graph.Watts_Strogatz(dim=1, size=20, nei=3, p=0.8)
    g_history, counts = simulation(g, n=5, m=0.3, b=0.3, limitation=0.5)
    plt.plot(counts[:, 0], label="Susceptible", c="orange")
    plt.plot(counts[:, 1], label="Infected", c="red")
    plt.plot(counts[:, 2], label="Recovered", c="green")

    plt.legend()
    plt.show()

    for g in g_history:
        plot(g)


if __name__ == "__main__":
    main()
