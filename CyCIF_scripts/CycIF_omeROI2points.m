function points = CycIF_omeROI2points(filename,no,sw1)
%% Read Omero ROIs and convert to point list
%  Jerry Lin 2020/10/21
%
%       filename: ROI filename
%       no: position of ROI
%       sw1: display flag
%

temp1 = readtable(filename,'Delimiter',',','ReadVariableNames',true);

if no <= size(temp1,1)
    temp2 = temp1.all_points(no);

    temp3 = split(temp2,' ');
    points = zeros(size(temp3,1),2);

    for i = 1:size(temp3,1)
        points(i,:) = str2num(temp3{i});
    end

    if sw1 == true
        figure,scatter(points(:,1),points(:,2));
        set(gca,'XAxisLocation','bottom','YAxisLocation','left','ydir','reverse');
        daspect([1 1 1]);
        title(filename);
    end
else
    points = [];
end

return;
