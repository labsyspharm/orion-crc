test1 = CycIF_importcsv('Results-TONSIL4.csv');
cellno = length(test1{:,1})/21;
allmeans = test1.Mean;
array1 = reshape(allmeans,cellno,21);
array1(:,22) = test1.Area(1:cellno);
array1(:,23) = test1.Circ(1:cellno);
array1(:,24) = test1.X(1:cellno);
array1(:,25) = test1.Y(1:cellno);
load('matlab-RC_HiPlex-20200424.mat', 'labels_tonsil')
dataTONSIL2 = array2table(array1,'VariableNames',labels_tonsil);
dataTONSIL2.Xt = dataTONSIL2.X*2;
dataTONSIL2.Yt = dataTONSIL2.Y*2;
dataTONSIL2{:,1:21}=dataTONSIL2{:,1:21}+exp(1);
