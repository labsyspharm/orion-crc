%% clusterXYpoints - Distance-based clustering of a set of XY coordinates
%
%
%  This function finds clusters in a set of spatial points expressed in
%  XY coordinates. The clustering is based on the distance between the
%  points and it does not require the number of clusters to be known
%  beforehand. Each point is clustered with the closest neighbouring point
%  if the distance between the two points is shorter than the user-defined
%  threshold.
%
%  The function outputs basic summary statistics on the screen and figures
%  showing the clusters, the centroid points and the geometric median
%  points of each clusters. It also creates two text files that contain the
%  coordinates of all centroid points and geometric median points.
%
%
%
%% Usage
%
% [clustersCentroids,clustersGeoMedians,clustersXY] = clusterXYpoints(inputfile,maxdist,minClusterSize,method,mergeflag);
%
%
%% Description of the variables:
%
% inputfile      : Path to a text file with two columns:
%                  - column 1: X values
%                  - column 2: Y values
%
% maxdist        : Maximum distance between points for the clustering.
%
% minClusterSize : Minimum number of points per cluster.
%
% method         : Determines the distance calculation method when adding
%                  points to an existing cluster. Possible methods are:
%                  - 'point': a point is added to an existing  cluster if
%                             it is within a 'maxdist' distance of any
%                             point of the cluster (default).
%                  - 'centroid': a point is added to an existing  cluster
%                             if it is within a 'maxdist' distance of the
%                             centroid of the cluster.
%                  - 'geometric median': a point is added to an existing
%                              cluster if it is within a 'maxdist' distance
%                              of the geometric median point of the
%                              cluster.
%
% mergeflag      : If set to 'merge', then clusters that are within a
%                  'maxdist' distance will be merged together. The distance
%                  calculation method is defined by the 'method' argument.
%
%
%
%% Author
%  Yann Marcon, Oct 2019
%
%% Version
%  1.5.0.0
%
%% Code
function [clustersCentroids,clustersGeoMedians,clustersXY] = clusterXYpoints(X1,Y1,maxdist,minClusterSize,method,mergeflag)
% Default variables
if exist('maxdist','var')~=1 || isempty(maxdist), maxdist = 10; end  % max distance between points for the clustering (in meters)
if exist('minClusterSize','var')~=1 || isempty(minClusterSize), minClusterSize = 1; end % minimum number of points per cluster
if exist('method','var')~=1 || isempty(method), method = 'point'; end % distance calculation method for adding points into existing clusters
% Pairwise distances
XY = horzcat(X1,Y1); % read X and Y
D = pdist(XY,'euclidean'); % compute pairwise distances between all points
kmax = size(XY,1);
% Preallocating the variable pairs for speed (thanks to CARLOS RANZ)
indexPairs = 0;
index = 1;
for k = 1:kmax
    indexPairs = indexPairs + kmax-k;
    if (k < kmax)
        index = [index; indexPairs+1];
    end
end
pairs = ones(indexPairs, 2); % column 1 = point1, column2 = point2
for k = 2:length(index )
    pairs(index(k-1):index(k)-1,:) = [ (k:kmax)' , (k-1) * ones(kmax-(k-1),1 ) ];
end
% Clustering
[Ds,IX] = sort(D,'ascend'); % sorts the distances in ascending order
pairs_sorted = pairs(IX,:);
clusters = {}; % list of clusters (one cell per cluster)
pointsInClusters = []; % keep track of which points are already in a cluster (row 1 = cluster number, row 2 = points in cluster)
inc = 0; % increment to keep track of the cluster number
for k = 1:numel(pairs(:,1))
    pt1 = pairs_sorted(k,1);
    pt2 = pairs_sorted(k,2);
    d = Ds(k); % distance between pt1 and pt2
    
    if d <= maxdist
        if isempty(pointsInClusters) || ...
                ( ~ismember(pt1,pointsInClusters(2,:)) && ...
                ~ismember(pt2,pointsInClusters(2,:)) )
            
            inc = inc + 1; % increment + 1 cluster
            
            currentCluster = [pt1,pt2];
            clusters = [ clusters ; {currentCluster} ]; % create new cluster.
            pointsInClusters = [ pointsInClusters , ...
                [ inc * ones(1,length(currentCluster)) ; currentCluster ] ];
            
        elseif ~ismember(pt1,pointsInClusters(2,:))
            id = pointsInClusters(1,pointsInClusters(2,:)==pt2); % find the number of the previous cluster where the point 'pt2' already exists.
            switch ['distance to ',lower(method)]
                case 'distance to centroid'
                    cdist = sqrt( sum((mean(XY(clusters{id},:),1) - XY(pt1,:)).^2) ); % distance between 'pt1' and cluster centroid.
                case 'distance to geometric median'
                    cdist = sqrt( sum((median(XY(clusters{id},:),1) - XY(pt1,:)).^2) ); % distance between 'pt1' and cluster median point.
                otherwise
                    cdist = [];
            end
            
            if isempty(cdist) || cdist <= maxdist % add 'pt1' to cluster if within 'maxdist' distance of centroid.
                clusters{id} = [ clusters{id} , pt1 ]; % add 'pt1' to the same cluster, in which 'pt2' is.
                pointsInClusters = [ pointsInClusters , [ id ; pt1 ] ]; % add 'pt1' to list of 'points in clusters'.
            end
            
        elseif ~ismember(pt2,pointsInClusters(2,:))
            id = pointsInClusters(1,pointsInClusters(2,:)==pt1); % find the number of the previous cluster where the point 'pt1' already exists.
            switch ['distance to ',lower(method)]
                case 'distance to centroid'
                    cdist = sqrt( sum((mean(XY(clusters{id},:),1) - XY(pt2,:)).^2) ); % distance between 'pt2' and cluster centroid.
                case 'distance to geometric median'
                    cdist = sqrt( sum((median(XY(clusters{id},:),1) - XY(pt2,:)).^2) ); % distance between 'pt2' and cluster median point.
                otherwise
                    cdist = [];
            end
            
            if isempty(cdist) || cdist <= maxdist % add 'pt2' to cluster if within 'maxdist' distance of centroid or median point.
                clusters{id} = [ clusters{id} , pt2 ]; % add 'pt2' to the same cluster, in which 'pt1' is.
                pointsInClusters = [ pointsInClusters , [ id ; pt2 ] ]; % add 'pt2' to list of 'points in clusters'.
            end
            
        else % if both points are already in different clusters
            if exist('mergeflag','var')==1 && strcmpi(mergeflag,'merge') % merge both clusters
                id1 = pointsInClusters(1,pointsInClusters(2,:)==pt1); % find the number of the previous cluster where the point 'pt1' already exists.
                id2 = pointsInClusters(1,pointsInClusters(2,:)==pt2); % find the number of the previous cluster where the point 'pt2' already exists.
                if id1~=id2 % merge clusters if different
                    switch ['distance to ',lower(method)]
                        case 'distance to centroid' % merge both clusters if their centroids are within a 'maxdist' distance of each other.
                            cdist = sqrt( sum((mean(XY(clusters{id1},:),1) - mean(XY(clusters{id2},:),1)).^2) ); % distance between cluster centroids.
                        case 'distance to geometric median' % merge both clusters if their median points are within a 'maxdist' distance of each other.
                            cdist = sqrt( sum((median(XY(clusters{id1},:),1) - median(XY(clusters{id2},:),1)).^2) ); % distance between cluster median points.
                        otherwise
                            cdist = [];
                    end
                    
                    if isempty(cdist) || cdist <= maxdist % merge clusters if within 'maxdist' distance.
                        clusters{id1} = [ clusters{id1} , clusters{id2} ]; % merge both clusters.
                        clusters{id2} = {}; % empty the second cluster (but do not delete it or the cell indices will be messed up!).
                        pointsInClusters(1,pointsInClusters(1,:)==id2) = id1; % replace id of cluster 2 with id of cluster cluster 1.
                    end
                end
            else % do not merge clusters
                % do nothing
            end
        end
    
    else % distance is greater than 'maxdist'
        break; % exit the 'for' loop
    end
        
end
clusters = clusters(cellfun(@(clusters) numel(clusters) >= minClusterSize, clusters)); % exclude clusters that are smaller than 'minClusterSize'.
clearvars pointsInClusters; % variable is not needed (and not up-to-date) past this point
% Make list of points that are not in a cluster
pointsNotInClusters = (1:kmax);
pointsNotInClusters = pointsNotInClusters(~ismember(pointsNotInClusters,cell2mat(clusters'))); % select points that are not already in a cluster
if minClusterSize < 2 % convert single points into 'one-point' clusters
    clusters = [ clusters ; num2cell(pointsNotInClusters)' ]; % create new clusters.
    pointsNotInClusters= []; % all points are not in a cluster
end
% Print summary values
clusterCount = numel(clusters); % Total number of clusters
sizeOfClusters = cellfun(@(clusters) numel(clusters), clusters);
clusterMinSize = min(sizeOfClusters);
clusterMaxSize = max(sizeOfClusters);
clusterMeanSize = mean(sizeOfClusters);
clusterMedianSize = median(sizeOfClusters);
singlepointCount = numel(pointsNotInClusters);
fprintf(1,'Number of clusters: %lu\n',clusterCount); % display the number of clusters
fprintf(1,'Size of smallest cluster: %lu\n',clusterMinSize); % display the number of clusters
fprintf(1,'Size of largest cluster: %lu\n',clusterMaxSize); % display the number of clusters
fprintf(1,'Mean cluster size: %f\n',clusterMeanSize); % display the number of clusters
fprintf(1,'Median cluster size: %lu\n',clusterMedianSize); % display the number of clusters
fprintf(1,'Number of points that are not part of any cluster: %lu\n',singlepointCount); % display the number of single points
% Write the XY coordinates of every points of every cluster
clustersXY = cell(clusterCount,1);
for k=1:clusterCount
    clustersXY{k,1} = XY(clusters{k,1},:);
end
% Compute the centroid (geometrical mean) of every cluster
clustersCentroids = NaN(clusterCount,2);
for k=1:clusterCount
    clustersCentroids(k,:) = mean(clustersXY{k,1},1);
end
% Compute the geometric median of every cluster
clustersGeoMedians = NaN(clusterCount,2);
for k=1:clusterCount
    clustersGeoMedians(k,:) = median(clustersXY{k,1},1);
end
% Plot the clusters
cc=hsv(clusterCount); % create different colour codes for every cluster
cc = cc(randperm(clusterCount),:); % randomise the colour codes so that neighbouring clusters don't have too similarly looking colours
h1 = figure('Name','Clusters');
hold on;
scatter(XY(:,1),XY(:,2),20,'filled','o','CData',[.8,.8,.8]); % plot the original points in light grey
for k=1:clusterCount
    plot(clustersXY{k,1}(:,1),clustersXY{k,1}(:,2),'o','Color',cc(k,:),'MarkerFaceColor',cc(k,:));
end
axis equal;
% Plot the centroid of each cluster
h2 = figure('Name','Centroids of clusters');
hold on;
scatter(XY(:,1),XY(:,2),20,'filled','o','CData',[.8,.8,.8]); % plot the original points in light grey
scatter(clustersCentroids(:,1),clustersCentroids(:,2),40,'filled','o','CData',cc); % plot the centroids
axis equal;
% Plot the geometric median of each cluster
h3 = figure('Name','Geometrical medians of clusters');
hold on;
scatter(XY(:,1),XY(:,2),20,'filled','o','CData',[.8,.8,.8]); % plot the original points in light grey
scatter(clustersGeoMedians(:,1),clustersGeoMedians(:,2),40,'filled','o','CData',cc); % plot the geometrical medians
axis equal;
% Write Centroids to file
outputfile = 'cluster_centroids.txt';
% write header line
fidout = fopen(outputfile,'w');
fprintf(fidout,'%s\t%s\n','X','Y');
fclose(fidout);
% write data
dlmwrite(outputfile,clustersCentroids,'-append','delimiter','\t','precision','%015.10f');
% Write geometric medians to file
outputfile = 'cluster_geometric-medians.txt';
% write header line
fidout = fopen(outputfile,'w');
fprintf(fidout,'%s\t%s\n','X','Y');
fclose(fidout);
% write data
dlmwrite(outputfile,clustersGeoMedians,'-append','delimiter','\t','precision','%015.10f');
end
