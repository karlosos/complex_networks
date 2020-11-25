"""
- [x] Przygotować sieć WS z około 20 węzłami
- [ ] Zaimplementować model aktywacji progowej (Linear Threshold)
    - wybieramy z sieci losowo m węzłów
    - zadany jest prób aktywacji, który określa jaki procent węzłów w sąsiedztwie jest wymagany do aktywacji węzła
    - w pierwszym kroku symulacji (t0) aktywizujemy losowo m węzłów (seed set) i oznaczamy je kolorem czerwonym
    - w kolejnych krokach dla każdego węzła sprawdzamy stan sąsiadów i jeśli liczba węzłów aktywnych jest <= n,
    zmieniamy stan węzła na aktywny (kolor czerwony)
    - proces trwa tak długo do momentu gdy nie występują już kolejne aktywacje
    - w każdym kroku zapisujemy do pliku liczbę aktywnych węzłów
    - stany grafu dla sprawdzenia prawidłowości procesu dokuemtnowane na poszczególnych wizualizacjach
"""
from igraph import *
import random
import numpy as np
import matplotlib.pyplot as plt


def seeding(g, m):
    """
    Random initialization of m nodes in graph g
    :param g: graph
    :param m: number of nodes to activate
    """
    indexes = g.vs.indices
    indexes_to_activate = random.sample(indexes, m)
    g.vs[indexes_to_activate]["activated"] = True


def update_colors(g):
    """
    :param g: graph
    """
    activated_indexes = list(np.where(g.vs["activated"])[0])
    g.vs[activated_indexes]["color"] = "red"


def update_labels(g):
    """
    :param g: graph
    """
    for i in g.vs.indices:
        g.vs[i]["neighbors_activated_count"] = np.sum([g.vs[n]["activated"] for n in g.neighbors(g.vs[i])])
    g.vs["label"] = [(g.vs.indices[i], g.vs[i]["neighbors_activated_count"], g.vs[i]["neighbors_count"]) for i in
                     range(len(g.vs.indices))]


def simulation_step(g, n):
    """
    Perform single iteration. For each node check if percentage of activated neighbors exceed
    threshold defined by n.
    :param g: graph
    :param n: threshold, required ratio of activated neighbors to activate
    """
    has_activation_happened = False
    for i in g.vs.indices:
        if not g.vs[i]["activated"]:
            neighbors_count = g.vs[i]["neighbors_count"]
            if neighbors_count:
                neighbors_activated_count = g.vs[i]["neighbors_activated_count"]
                neighbors_activated_ratio = neighbors_activated_count/neighbors_count
                if neighbors_activated_ratio > n:
                    g.vs[i]["activated"] = True
                    has_activation_happened = True

    update_colors(g)
    update_labels(g)
    activated_nodes_count = np.sum(g.vs["activated"])
    return g, activated_nodes_count, has_activation_happened


def simulation(g, m, n):
    g.vs["activated"] = False
    for i in g.vs.indices:
        g.vs[i]["neighbors_count"] = len(g.neighbors(g.vs[i]))
    g.vs["color"] = "orange"
    g.vs["size"] = 50

    seeding(g, m=m)
    update_colors(g)
    update_labels(g)
    # plot(g)

    g_history = [deepcopy(g)]
    activated_nodes_counts = [np.sum(g.vs["activated"])]
    has_activation_happened = True
    while has_activation_happened:
        g, activated_nodes_count, has_activation_happened = simulation_step(g, n)
        g_history.append(deepcopy(g))
        activated_nodes_counts.append(activated_nodes_count)
        # plot(g)
    return g_history, activated_nodes_counts


def main():
    g = Graph.Watts_Strogatz(dim=1, size=20, nei=3, p=0.8)
    g_history, activated_nodes_counts = simulation(g, m=5, n=0.3)
    plt.plot(activated_nodes_counts)
    plt.show()

    for g in g_history:
        plot(g)


if __name__ == '__main__':
    # main()
    g = Graph.Watts_Strogatz(dim=1, size=50, nei=5, p=0.8)
    plot(g)
