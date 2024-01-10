function [g] = grabgraphlets (G, L, n)

% This code takes a symmetric adjacency matric G and a string of labels L 
% to identify all unrooted labeled graphlets of size n. The output g is a 
% cell array where each element contains a graphlet adjacency matrix .G and
% a string .L. These then need to be later permuted to identify automorphic
% structure of miminal "score" which is what we actually need to count.
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

g = {};
k = 1;

% the graph must include the first node
if n == 1
    g{1}.G = G(1, 1);
    g{1}.L = L(1);
    %g{1}.W = W(1);
elseif n == 2
    no_nodes = size(G, 1);
    for i = 2 : no_nodes
        t = G([1 i], [1 i]);
        if length(unique(conncomp(graph(t)))) == 1
            g{k}.G = t;
            g{k}.L = L([1 i]);
            %g{k}.W = W([1 i]);
            k = k + 1;
        end
    end
elseif n == 3
    no_nodes = size(G, 1);
    for i = 2 : no_nodes - 1
        for ii = i + 1 : no_nodes
            t = G([1 i ii], [1 i ii]);
            if length(unique(conncomp(graph(t)))) == 1
                g{k}.G = t;
                g{k}.L = L([1 i ii]);
                %g{k}.W = W([1 i ii]);
                k = k + 1;
            end
        end
    end
elseif n == 4
    no_nodes = size(G, 1);

    % sort nodes in graph relative to node 1 in G
    [G, L, d] = sortgraph(G, L, 1);
    
    % now we go to node 2 in the graph
    % if the distance of node 2 is > 1, abort (nodes are sorted above)
    for i = 2 : no_nodes - 2
        % d(i) > 1 works if the distance is Inf. Verified.
        if d(i) > 1 
            break 
        end
        for ii = i + 1 : no_nodes - 1
            if isinf(d(ii))
                continue
            end
            for iii = ii + 1 : no_nodes
                if isinf(d(iii))
                    continue
                end
                t = G([1 i ii iii], [1 i ii iii]);
                if length(unique(conncomp(graph(t)))) == 1
                    g{k}.G = t;
                    g{k}.L = L([1 i ii iii]);
                    %g{k}.W = W([1 i ii iii]);
                    k = k + 1;
                end
            end
        end
    end
elseif n == 5
    no_nodes = size(G, 1);

    [G, L, d] = sortgraph(G, L, 1);

    for i = 2 : no_nodes - 3
        if d(i) > 1
            break 
        end
        for ii = i + 1 : no_nodes - 2
            if isinf(d(ii))
                continue
            end
            for iii = ii + 1 : no_nodes - 1
                if isinf(d(iii))
                    continue
                end
                for iiii = iii + 1 : no_nodes
                    if isinf(d(iiii))
                        continue
                    end

                    t = G([1 i ii iii iiii], [1 i ii iii iiii]);
                    if length(unique(conncomp(graph(t)))) == 1
                        g{k}.G = t;
                        g{k}.L = L([1 i ii iii iiii]);
                        %g{k}.W = W([1 i ii iii iiii]);
                        k = k + 1;
                    end
                end
            end
        end
    end
else
    error('Incorrect graphlet size.')
end

return
