# Fundamental of Probabilistic Learning

## D-separation

    Definition: Let A, B and C be 3 non intersecting sets of nodes of a direted acyclic graph. A and B are D-separated by C if all paths from any node from A to B are blocked by C

## Markovian Dependency

    Principal: Each variable depends only on its closer neighbours
### D-separation in Markovian Model

### Markov blanket

    Definition: the minimal set that D-separate a set of nodes from the rest of the graph.

Construction: Given a directed acyclic graph and a node X, the Markov blanket of X $\beta_X$ is the set of all parents, children and co-parent of X