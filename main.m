clear
% clc

global BaseGraphs

% alphabet = 'ACDEFGHIKLMNPQRSTVWY';

alphabet = 'ACDEFGHIKLMNPQRSTVWYacdefghiklmnpqrstvwy';

load UnrootedGraphlets.mat
load phosY
% G = read_svml('data/P04637/residues.adj');
% L = fileread('data/P04637/wildtype.labels');
disp(size(L))
% graphlets to count
%ns = [1 2 3 4 5];
ns = [1 2 3 4 5];

tic
[v, g] = countgraphlets(G, L, ns, alphabet);
toc
% f = @()wrapper(G,L,ns,alphabet);
% timeit(f,2)

% sum(v)
%for i = 1 : length(g)
%    g{i}.G
%    g{i}.L
%end

function [v,g]=wrapper(G,L,ns,alphabet)
    [v,g] = countgraphlets(G,L,ns, alphabet);
end