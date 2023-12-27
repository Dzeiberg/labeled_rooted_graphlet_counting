function [countvector, graphlets] = countgraphlets (G, L, BaseGraphs, ns, alphabet)

% This function takes a graph adjacency matric G and a string of node
% labels L to then give a count vector that can be used as a feature
% vector. The output element graphlets contains the same thing as the
% count vector but it does give each graph as well as the label string.
% If we only want a feature vector, we don't need graphlets, we just need
% counts.
%
% Inputs:
%         G = symmetric adjacency matrix; only 0s or 1s
%         L = a string of node labels in the same order as nodes in G;
%             length must equal the dimensioins of G
%         BaseGraphs = cell array of base graphlets that should be counted
%         ns = a vector of integers from {1, 2, 3, 4, 5}
%         alphabet = a string of allowed characters
%
% Outputs: countvector = a row vector of counts of graphlets
%          graphlets = graphlets found in the big graph G
%
% Predrag Radivojac
% Northeastern University
%
% First created:
% December 13, 2023
% Boston, MA 02115
%
% Last update:
% December 23, 2023
% Boston, MA 02115


% Cell array where each element is one graphlet with its matrix (G), label
% sequence (L), index of sorted labels (S) and type of graphlet (B).
% Graphlets observed more than once will appear here as duplicates.
graphlets = {};

% Sparse feature vector of counts. If a graphlet is observed more than
% once, the countvector will have an appropriate count for that graphlet
countvector = [];

for n = ns
    % precompute all permutations with n elements, to find isomorphisms
    P = perms(1 : n);
    no_perm = size(P, 1);

    % precompute the number of edges in each base graphlet
    edgesbg = zeros(1, length(BaseGraphs{n}));
    for k = 1 : length(BaseGraphs{n})
        edgesbg(k) = sum(sum(BaseGraphs{n}{k}.G));
    end

    % start finding graphlets in G;
    % we will count graphlets that contain node i and go from there
    for i = 1 : size(G, 1)
        % distances from node i to nodes with index at least i
        d = distances(graph(G), i, i : size(G, 1));

        % find nodes where the shortest path from i is less than n
        q = find(d < n) + i - 1;

        % find graphlets using indices q, but they are not "oriented" yet
        g = grabgraphlets(G(q, q), L(q), n);

        % now, orient those graphlets
        for j = 1 : length(g)
            edges = sum(sum(g{j}.G)); % how many edges in this graph?

            minscore = Inf; % something really large

            next = length(graphlets) + 1; % graphlet to be added

            % for each graphlet g{j} found, loop over all base graphlets
            for k = 1 : length(BaseGraphs{n})
                bg = BaseGraphs{n}{k}.G;
                if edges == edgesbg(k)
                    for l = 1 : no_perm
                        % permute base graph (to try to get g{j}.G)
                        R = eye(n);
                        R = R(:, [P(l, :)]);
                        t = R * bg * R';

                        % is permuted bg isomorphic with g{j}.G
                        if isequal(g{j}.G, t)
                            % permute labels
                            label = g{j}.L(P(l, :));

                            % score to sort automorphic labelings
                            score = getscore(label, alphabet);

                            % if graph is identical and label minimized
                            if score < minscore
                                minscore = score;
                                %graphlets{next}.G = bg; % not needed as it
                                                         % can be recovered
                                                         % from .B
                                graphlets{next}.L = label;
                                %graphlets{next}.W = mean(g{j}.W(P(l, :)));
                                graphlets{next}.S = score;
                                graphlets{next}.B = k;
                            end
                        end
                    end
                end
            end
            % if the graph g{j}.G is not found, it's a problem
            if isinf(minscore)
                error('Problem with counting');
            end
        end
    end

    % count vector for each graphlet size n
    % using "sparse" representation makes this really slow somehow
    % one should not replace "zeros" with "sparse"
    v{n} = zeros(1, length(BaseGraphs{n}) * length(alphabet) ^ n);
    for i = 1 : length(graphlets)
        % find position in v{n}, then increment the count
        position = graphlets{i}.S + (graphlets{i}.B - 1) * ...
            length(alphabet) ^ n;
        v{n}(position) = v{n}(position) + 1;
        %v{n}(position) = v{n}(position) + graphlets{i}.W;
    end
    countvector = [countvector v{n}];
end

return
