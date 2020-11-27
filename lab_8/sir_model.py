"""
- [x] Przygotować sieć WS z około 20 węzłami
- Model SIR przy założeniach
    - wybieramy z sieci losowo n węzłów 
    - zadany jest próg aktywacji b który określa prawdopodobieństwo przekazania informacji
    - pradopodobieństwo `m` przejścia ze stanu infected I do removed R
    - [x] w pierwszym kroku symulacji t0 aktywizujemy losowo n węzłów (seed set) i
    oznaczamy je kolorem czerwonym (pogląd na wizualizacji grafu)
    - w kolejnych krokach każdy węzeł ze stanem I kontuje się z każdym sąsiadem i z
    prawdopodobieństwem b go infekuje. Następnie węzły zainfekowane przechodzą do stanu R 
    z prawdopodobieństwem m.
    - proces trwa do momentu przejścia wszystkich węzłów do stanu R
    - w każdym kroku zapisujemy do pliku liczbę węzłów w każdym ze stanów
    - na koniec procesu powstaje wykres z liczbą węzłów w każdym stanie
- finish when there is noone in I

Possible states = ["S", "I", "R"]
"""
from igraph import *
import random
import numpy as np
import matplotlib.pyplot as plt


def seeding(g, n):
    """
    Random initialization of n nodes in graph g
    :param g: graph
    :param n: number of nodes to activate
    """
    indexes = g.vs.indices
    indexes_to_infect = random.sample(indexes, n)
    g.vs[indexes_to_infect]["state"] = "I" 
    print(g.vs[indexes_to_infect])


def update_colors(g):
    """
    :param g: graph
    """
    activated_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    print(np.where(g.vs["state"] == "I"))
    print(activated_indexes)
    g.vs[activated_indexes]["color"] = "red"


def update_labels(g):
    """
    :param g: graph
    """
    for i in g.vs.indices:
        g.vs["label"] = [g.vs.indices[i]]


def infection(g, b):
    print("infection")
    infected_indexes = list(np.where(np.array(g.vs["state"]) == "I")[0])
    print("now")
    for i in infected_indexes:
        print(g.vs[i])
        susceptible_neighbors = g.vs[g.neighbors(g.vs[i])] == "I"
        probs = np.random.rand(len(neighbors))
        indexes_to_infect = neighbors[probs < b]
        print(indexes_to_infect)
        # print(neighbors)
        # print(probs)
        # print(probs < b)
        # print(indexes_to_infect)
        # g.vs[indexes_to_infect]["state"] = "I"


def recovery(g, m):
    pass


def calculate_states(g):
    return 0, 0, 0


def simulation(g, n, m):
    """
    SIR simulation
    :param g: graph
    :param n: number of initial infected nodes
    :param m: probability of recovery
    """
    g.vs["state"] = "S" 
    g.vs["color"] = "orange"
    g.vs["size"] = 50

    seeding(g, n=n)
    update_colors(g)
    update_labels(g)
    # plot(g)
    g_history = [deepcopy(g)]
    flag = True
    while flag:
        infection(g, b=0.3)
        recovery(g, m)
        s_count, i_count, r_count = calculate_states(g)
        flag = i_count != 0
        g_history.append(deepcopy(g))

    # g_history = [deepcopy(g)]
    # activated_nodes_counts = [np.sum(g.vs["activated"])]
    # has_activation_happened = True
    # while has_activation_happened:
    #     g, activated_nodes_count, has_activation_happened = simulation_step(g, n)
    #     g_history.append(deepcopy(g))
    #     activated_nodes_counts.append(activated_nodes_count)
    #     # plot(g)
    return g_history, 0


def main():
    g = Graph.Watts_Strogatz(dim=1, size=20, nei=3, p=0.8)
    g_history, activated_nodes_counts = simulation(g, n=5, m=0.3)
    # plt.plot(activated_nodes_counts)
    # plt.show()

    # for g in g_history:
    #     plot(g)


if __name__ == '__main__':
    main()
    # g = Graph.Watts_Strogatz(dim=1, size=50, nei=5, p=0.8)
    # plot(g)
