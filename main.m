clear
clc

%global BaseGraphs

alphabet = 'ACDEFGHIKLMNPQRSTVWY';

%alphabet = 'ACDEFGHIKLMNPQRSTVWYacdefghiklmnpqrstvwy';

load UnrootedGraphlets.mat
%load phosY
load p53
%load P04637_CA_6.mat
%G = read_svml('P04637.min4.5.adj');


% manually add weights for nodes in anticipation we'll have it later
% NOT DONE YET, BUT PREPARED
%W = ones(1, length(L));


% permute G and L to look at algorithm's correctness and run time
[G, L] = permutelabeledgraph (G, L);

% graphlets to count
ns = [1 2 3 4 5];
%ns = [3];

tic
%[v, g] = countgraphlets(G, L, BaseGraphs, ns, alphabet);
v = countgraphlets(G, L, BaseGraphs, ns, alphabet);
toc

return 

% print graphlets (works only if countgraphlets is done for a single n)
f = zeros(1, length(v));
for i = 1 : length(g)
    c = g{i}.S + (g{i}.B - 1) * length(alphabet) ^ length(g{i}.L);
    if f(c) == 0
        fprintf('(%d, %d) %s %d\n', length(g{i}.L), g{i}.B, g{i}.L, full(v(c)));
        f(c) = 1;
    end
end

%for i = 1 : length(g)
%    g{i}.G
%    g{i}.L
%end

% Plot base graphs
% for n = 1 : 5
%     for k = 1 : length(BaseGraphs{n})
%         plot(graph(BaseGraphs{n}{k}.G));
%         pause
%     end
% end