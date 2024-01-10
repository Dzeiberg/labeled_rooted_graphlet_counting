function exitcode = run_main(distance_matrix_filepath, nodelabels_filepath, outputfile, alphabet_size, distance_threshold)
    load UnrootedGraphlets.mat;
    exitcode = 0;
    % graphlets to count
    ns = [1 2 3 4 5];
    if ischar(alphabet_size)
        alphabet_size = str2num(alphabet_size);
    end
    if ischar(distance_threshold)
        distance_threshold = str2num(distance_threshold);
    end
    if alphabet_size == 20
        alphabet = 'ACDEFGHIKLMNPQRSTVWY';
    elseif alphabet_size == 40
        alphabet = 'ACDEFGHIKLMNPQRSTVWYacdefghiklmnpqrstvwy';
    else
        % throw an error
        error('cannot parse alphabet_size')
    end
    G = load(distance_matrix_filepath,'CA_Distances');
    % set all off-diagonal elements less than distance threshold to 1
    G = G.CA_Distances < distance_threshold;
    % set diagonal elements to 0
    G = G - diag(diag(G));

    % load node labels
    L = fileread(nodelabels_filepath);

    if length(G) ~= length(L)
        error('Graph and node label files do not match');
    end
    
    % manually add weights for nodes in anticipation we'll have it later
    % NOT DONE YET, BUT PREPARED
    %W = ones(1, length(L));
    
    
    % permute G and L to look at algorithm's correctness and run time
    [G, L] = permutelabeledgraph (G, L);
    
    tic
    [v, g] = countgraphlets(G, L, BaseGraphs, ns, alphabet);
    toc 
    % save the graphlet count vector and graphlets to a file
    save(outputfile, 'v', 'g');
    return

    % print graphlets (works only if countgraphlets is done for a single n)
    % f = zeros(1, length(v));
    % for i = 1 : length(g)
    %     c = g{i}.S + (g{i}.B - 1) * length(alphabet) ^ length(g{i}.L);
    %     if f(c) == 0
    %         fprintf('(%d, %d) %s %d\n', length(g{i}.L), g{i}.B, g{i}.L, full(v(c)));
    %         f(c) = 1;
    %     end
    % end
    
    % %for i = 1 : length(g)
    % %    g{i}.G
    % %    g{i}.L
    % %end
    
    % % Plot base graphs
    % % for n = 1 : 5
    % %     for k = 1 : length(BaseGraphs{n})
    % %         plot(graph(BaseGraphs{n}{k}.G));
    % %         pause
    % %     end
    % % end
end