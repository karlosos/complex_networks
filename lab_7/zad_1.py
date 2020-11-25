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
    degrees = [d for d in g.degree()]  # TODO: change to number of activated neighbors
    # print(g.neighbors(g.vs[1]))
    g.vs["label"] = [(g.vs.indices[i], degrees[i]) for i in range(len(degrees))]


def main():
    g = Graph.Watts_Strogatz(dim=1, size=20, nei=3, p=0.3)
    g.vs["activated"] = False
    g.vs["color"] = "orange"
    g.vs["size"] = 50
    seeding(g, 5)
    update_colors(g)
    update_labels(g)

    # g.vs[2]["color"] = "red"
    plot(g)


if __name__ == '__main__':
    main()
