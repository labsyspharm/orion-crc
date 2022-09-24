%% CycIF_assign all Ome ROIs new
%  Jerry Lin 2021/08/26
%  Need filelist

for i = 17:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    data1 = CycIF_assignOmeroROIsingle(data1,filelist{i},0.65,false);
    roiTable = readtable(filelist{i});
    eval(strcat('roi',slideName{i},'=roiTable;'));
    eval(strcat('data',slideName{i},'=data1;'));
end

clear data1;
