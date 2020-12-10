from igraph import *
import random
import numpy as np
import matplotlib.pyplot as plt


def simulation(g, m, infection_1_params, infection_2_params):
    """
    Concurent SIR Model simulation
    :param g: graph
    :param m: probability of recovery
    :param infection_1_params: (n, b) tuple with n - random seeding , b - transmission rate (probability of infection)
    :param infection_2_params: (n, b) tuple with n - random seeding , b - transmission rate (probability of infection)
    :return: list of graphs in each step, array of S, I1, I2, R counts
    """
    g.vs["state"] = "S"
    g.vs["color"] = "gray"
    g.vs["size"] = 50

    (n_1, b_1) = infection_1_params
    (n_2, b_2) = infection_2_params

    seeding(g, n=n_1, new_state="I1")
    seeding(g, n=n_2, new_state="I2")
    update_colors(g)

    g_history = [deepcopy(g)]
    counts = [count_states(g)]
    flag = True
    while flag:
        infection(g, b_1, b_2)
        recovery(g, m=m)
        update_colors(g)
        s_count, i_1_count, i_2_count, r_count = count_states(g)
        counts.append((s_count, i_1_count, i_2_count, r_count))
        flag = (i_1_count + i_2_count) != 0
        g_history.append(deepcopy(g))

    return g_history, np.array(counts)


def seeding(g, n, new_state):
    indexes = list(np.where(np.array(g.vs["state"]) == "S")[0])
    indexes_to_infect = random.sample(indexes, n)
    g.vs[indexes_to_infect]["state"] = new_state
    print(g.vs[indexes_to_infect])


def update_colors(g):
    infected_1_indexes = list(np.where(np.array(g.vs["state"]) == "I1")[0])
    g.vs[infected_1_indexes]["color"] = "red"
    infected_2_indexes = list(np.where(np.array(g.vs["state"]) == "I2")[0])
    g.vs[infected_2_indexes]["color"] = "blue"
    recovered_indexes = list(np.where(np.array(g.vs["state"]) == "R")[0])
    g.vs[recovered_indexes]["color"] = "green"


def infection(g, b_1, b_2):
    infected_indexes = get_infected_indexes(g)
    for i in infected_indexes:
        neighbors = g.neighbors(g.vs[i])
        for neighbor in neighbors:
            if g.vs[neighbor]["state"] == "S":
                b = b_1 if g.vs[i]["state"] == "I1" else b_2
                if np.random.rand() < b:
                    g.vs[neighbor]["state"] = g.vs[i]["state"]


def recovery(g, m):
    infected_indexes = get_infected_indexes(g)
    for i in infected_indexes:
        if np.random.rand() < m:
            g.vs[i]["state"] = "R"


def get_infected_indexes(g):
    infected_1_indexes = list(np.where(np.array(g.vs["state"]) == "I1")[0])
    infected_2_indexes = list(np.where(np.array(g.vs["state"]) == "I2")[0])
    infected_indexes = infected_1_indexes + infected_2_indexes
    random.shuffle(infected_indexes)
    return infected_indexes


def count_states(g):
    infected_1_indexes = list(np.where(np.array(g.vs["state"]) == "I1")[0])
    infected_2_indexes = list(np.where(np.array(g.vs["state"]) == "I2")[0])
    recovered_indexes = list(np.where(np.array(g.vs["state"]) == "R")[0])
    susceptible_indexes = list(np.where(np.array(g.vs["state"]) == "S")[0])
    return (
        len(susceptible_indexes),
        len(infected_1_indexes),
        len(infected_2_indexes),
        len(recovered_indexes),
    )


def main():
    graph_size = 1000
    g = Graph.Watts_Strogatz(dim=1, size=graph_size, nei=3, p=0.8)

    transmission_rates = [0.1, 0.2]
    n = int(graph_size * 0.05) # 5% of nodes infected

    fig, axes = plt.subplots(2, 2)
    ax_idx = 0

    for b_1 in transmission_rates:
        for b_2 in transmission_rates:
            g_history, counts = simulation(
                g, m=0.1, infection_1_params=(n, b_1), infection_2_params=(n, b_2)
            )

            ax = axes.flat[ax_idx]
            ax.plot(counts[:, 0], label="Susceptible", c="gray")
            ax.plot(counts[:, 1], label="Infected 1", c="red")
            ax.plot(counts[:, 2], label="Infected 2", c="blue")
            ax.plot(counts[:, 3], label="Recovered", c="green")
            ax.set_title(f"$b_1$ = {b_1}, $b_2$ = {b_2}")
            ax.legend()
            ax_idx += 1

    plt.tight_layout()
    plt.show()

    # for g in g_history:
    #     plot(g)


if __name__ == "__main__":
    main()
