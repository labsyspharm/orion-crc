%% CycIF_assign all Ome ROIs new
%  Jerry Lin 2021/08/26
%  Need filelist

for i = 1:length(slideName)
    disp(strcat('Processing:',slideName{i}));
    data1 = eval(strcat('data',slideName{i}));
    %data1.ROIold = data1.ROI;
    data1 = CycIF_assignOmeroROIsingle(data1,filelist{i},0.65,'TLS');
    eval(strcat('data',slideName{i},'=data1;'));
end
