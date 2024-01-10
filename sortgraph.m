function [G, L, d] = sortgraph (G, L, nodeindex)

% This function sorts a graph G with labels L based on the shortest path
% distance from node nodeindex in G.

% check distances to sort the graph
d = distances(graph(G), nodeindex, 1 : size(G, 1));

% sort the graph so that the order is in nondecreasing shortest paths
[d, indices] = sort(d);

% create permutation matrix P
P = eye(length(d));
P = P(:, indices);

% sort graph's adjacency matrix
G = P' * G * P;

% sort node labels
L = L(indices);

return