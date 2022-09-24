function CycIF_disPostiveCells(data1,marker1,imagename,imagedir)
%% CycIF script for display overlay between postive cells & images
% Jerry Lin 2017/08/10


%% Initialization
data2 = data1{:,marker1};
figure;
[data1.pluscells,~,~,~,~] = findgate3(log(data2+5),1,0.02,0);
names = data1.Properties.VariableNames;

allchs = find(ismember(names,'AREA'))-1;
targetch = find(ismember(names,marker1));

cycles =allchs/4;

chs = floor(targetch/cycles)+1;
cycle = mod(targetch,cycles);

index = (cycle-1)*4+chs;

framecount = tabulate(data1{data1.pluscells,'frame'});
framecount =sortrows(framecount,2,'descend');

%% display second of the best frame
frame = framecount(2,1);
framedata = data1(data1.frame ==frame,:);
filename = strcat(imagedir,imagename,'-',num2str(frame),'.tif');

image1 = imread(filename,index);
image1 = cat(3,image1,image1,image1);
image1 = image1*50;

figure;
subplot(1,2,1);
imagesc(image1);
title(strcat('frame',num2str(frame),{' '},marker1));
subplot(1,2,2);
imagesc(image1);
hold on;
plusdata = framedata(framedata.pluscells==1,:);
scatter(framedata.X,framedata.Y,15,'b','fill');
scatter(plusdata.X,plusdata.Y,20,'r','fill');
legend({'All cells','Positve cells'});
hold off;

title('overlay with postive cells');

%% display 10th frames
frame = framecount(10,1);
framedata = data1(data1.frame ==frame,:);
filename = strcat(imagedir,imagename,'-',num2str(frame),'.tif');

image1 = imread(filename,index);
image1 = cat(3,image1,image1,image1);
image1 = image1*50;

figure;
subplot(1,2,1);
imagesc(image1);
title(strcat('frame',num2str(frame),{' '},marker1));
subplot(1,2,2);
imagesc(image1);
hold on;
plusdata = framedata(framedata.pluscells==1,:);
scatter(framedata.X,framedata.Y,15,'b','fill');
scatter(plusdata.X,plusdata.Y,20,'r','fill');
legend({'All cells','Positve cells'});
hold off;

title('overlay with postive cells');