function [G, L] = permutelabeledgraph (G, L)

% Permutes the order of labeled nodes in part to test the performance of
% graphlet counting. Not sure where else this function can be useful.
%
% Predrag Radivojac
% Northeastern University
%
% December 23, 2023
% Boston, MA 02115
% U.S.A.

p = randperm(size(G, 1));
R = eye(size(G, 1));
R = R(:, p);
G = R' * G * R;
L = L(p);

return