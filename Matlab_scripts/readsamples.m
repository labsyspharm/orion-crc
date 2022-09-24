%% TRIPLET read all sample csv files
%  Jerry Lin 2017/03/15


%%Initialization

alldata = cell(24,2);

for i=1:24
    alldata(i,1) = datalabels(i);
    alldata{i,2} = readtable(filenames{i});
end





