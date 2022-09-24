function newTable = CycIF_assignROI_oval(myTable,myROIfile,myScale)
%% CycIF_assignROI.m 
%  Read ROI from imageJ (RoiSet.zip) and assign back to original table
%  Jerry Lin    2018/06/26

% myROIfile = ROI file name (RoiSet.zip)
% myTable =  the data table name
% myScale =  coverting factor (default: 3.25 for RareCyte 2x2 binning with 0.2x Montage)
%            coverting factor for ashlar 20x = 10.35
%            coverting factor for Orion 20x (level 4) = 2.6 
%

%% Initialization
dataTemp = myTable;


%% Read ROIs & assign to each cells

[sROI]=ReadImageJROI(myROIfile);
dataTemp.ROI = zeros(length(dataTemp.Xt),1);

if length(sROI)>1
  for i=1:length(sROI)
    points = sROI{i}.vnRectBounds*myScale;
    in = inpolygon(dataTemp.Xt,dataTemp.Yt,[points(2),points(4),points(4),points(2),points(2)],[points(1),points(1),points(3),points(3),points(1)]);
    dataTemp{in,'ROI'}=i;
  end
else
    i=1;
    points = sROI.vnRectBounds*myScale;
    in = inpolygon(dataTemp.Xt,dataTemp.Yt,[points(2),points(4),points(4),points(2),points(2)],[points(1),points(1),points(3),points(3),points(1)]);
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

