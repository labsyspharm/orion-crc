function adjmat = delaunaygraph(xypoints,cutoff)

    tri = delaunay(xypoints(:,1),xypoints(:,2));
    trilist = tri(:);
    trinext = reshape(tri(:,[2 3 1]),size(trilist));
    tridist = sqrt(sum((xypoints(trilist,:) - xypoints(trinext,:)).^2,2));
    %edgeprune = tridist<cutoff;
    g = digraph(trilist,trinext,tridist);
    A = adjacency(g,'weighted');
    A = (A + A')/2;
    A(A>cutoff)=0;
    adjmat = A;%logical(A);
    
return;


%comment out the last line if you don't want ot display the graph
%H = plot(graph(adjmat),'XData',xypoints(:,1),'YData',xypoints(:,2));