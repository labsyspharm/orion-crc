function newtable = CycIF_assignOmeroROIsingle(data1,filename)
%% Script to read & assign ROI from Omero ROI (Yu-AN's script)
%  apply single ROI csv & data table
%  Jerry Lin 2021/08/25

%data1 = eval(strcat('data',slideName{i}));

%filename = ROI_list{i};
%disp(filename);

p = 1;
[points, = CycIF_omeROI2points(filename,p,false);

data1.ROI = zeros(size(data1,1),1);
data1.ROIname = cell(size(data1,1),1);

while ~isempty(points)
    disp(size(points,1));
    points = points * 0.65;

    flag1 = inpolygon(data1.Xt,data1.Yt,points(:,1),points(:,2));
    data1.ROI(flag1) = p;

    p = p+1;
    points = CycIF_omeROI2points(filename,p,false);
end

newtable = data1;

return
