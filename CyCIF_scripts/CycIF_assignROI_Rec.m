function newTable = CycIF_assignROI_Rec(myTable,myROIfile,myScale)
%% CycIF_assignROI.m 
%  Read ROI from imageJ (RoiSet.zip) and assign back to original table
%  Jerry Lin    2017/10/07
%  Jerry Lin    2018/06/26:  Add feature: display ROI numbers
%  Jerry Lin    2019/11/23:  Rectangle ROIs

% myROIfile = ROI file name (RoiSet.zip)
% myTable =  the data table name
% myScale =  coverting facotr (default: 3.25 (5.2) for RareCyte 2x2 binning with 0.2x Montage)
% myScale =  coverting facotr (default: 5.2 for RareCyte 2x2 binning with level 4 Ashlar)

%% Initialization
dataTemp = myTable;


%% Read ROIs & assign to each cells

[sROI]=ReadImageJROI(myROIfile);
dataTemp.ROI = zeros(length(dataTemp.Xt),1);

if length(sROI)>1
  for i=1:length(sROI)
    s1 = sROI{i}.vnRectBounds;
    points = [s1(1),s1(3),s1(3),s1(1);s1(2),s1(2),s1(4),s1(4)];
    %points = sROI{i}.mnCoordinates*myScale;
    in = inpolygon(dataTemp.Xt,dataTemp.Yt,points(:,1),points(:,2));
    dataTemp{in,'ROI'}=i;
  end
else
    i=1;
    points = sROI.mnCoordinates*myScale;
    in = inpolygon(dataTemp.Xt,dataTemp.Yt,points(:,1),points(:,2));
    dataTemp{in,'ROI'}=i;
end

%% Display ROIs
sample1 = datasample(dataTemp,20000);

figure,scatter(sample1.Xt,sample1.Yt,10,sample1.ROI,'fill');colormap(jet(i+1));colorbar;
set(gca,'Ydir','reverse');

if length(sROI)>1
    for i=1:length(sROI)
        tempROI = dataTemp(dataTemp.ROI ==i,:);
        X1 = mean(tempROI.Xt);
        Y1 = mean(tempROI.Yt);
        text(X1,Y1,num2str(i),'HorizontalAlignment','center','BackgroundColor','white');
    end
else
    i=1;
    tempROI = dataTemp(dataTemp.ROI == i,:);
    X1 = mean(tempROI.Xt);
    Y1 = mean(tempROI.Yt);
    text(X1,Y1,num2str(i),'HorizontalAlignment','center','BackgroundColor','white');
end
%% Write to original table and clear temp table
newTable = dataTemp;

return;

