clear
clc

global BaseGraphs

%alphabet = 'ACDEFGHIKLMNPQRSTVWY';

alphabet = 'ACDEFGHIKLMNPQRSTVWYacdefghiklmnpqrstvwy';

load UnrootedGraphlets.mat
%load phosY
G = read_svml('residues.adj');
L = fileread('wildtype.labels');
% graphlets to count
%ns = [1 2 3 4 5];
ns = [1 2 3 4 5];

tic
[v, g] = countgraphlets(G, L, ns, alphabet);
toc

%for i = 1 : length(g)
%    g{i}.G
%    g{i}.L
%end