%% Generate pairwise distance matrix for CycIF data
%% Input two gated dataset/celltype and return distance matrix

function matrix1 = pairdist1(data1,data2)

%size1 = size(data1,1);
%size2 = size(data2,1);

%matrix1 = zeros(size1,size2);
x(:,1)= data1.Xt;
x(:,2)= data1.Yt;
y(:,1) = data2.Xt;
y(:,2) = data2.Yt;
matrix1 = pdist2(x,y,'euclidean');

return;

    
        