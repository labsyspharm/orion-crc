function image0 =CycIF_imageoverlay2(frame,framedata,marker1,gate1,imagename,imagedir)
%% display image with gate overlay
% Jerry Lin 2017/08/10

%frame = framecount(2,1);
%framedata = data1(data1.frame ==frame,:);
filename = strcat(imagedir,imagename,'-',num2str(frame),'.tif');
names = framedata.Properties.VariableNames;

%calculate image index
allchs = find(ismember(names,'AREA'))-1;
targetch = find(ismember(names,marker1));

cycles =allchs/4;

chs = floor(targetch/cycles)+1;
cycle = mod(targetch,cycles);

index = (cycle-1)*4+chs;

%open image
image0 = imread(filename,index);
image1 = cat(3,image0,image0,image0);
image1 = image1*sqrt(65535/double(prctile(image0(:),50)));

%plot figures
figure;
subplot(1,2,1);
imagesc(image1);
title(strcat('Frame',num2str(frame),{' '},marker1));
subplot(1,2,2);
imagesc(image1);
hold on;

if(strcmp(marker1,gate1))
    scatter(framedata.X*0.77,framedata.Y*0.77,15,log(framedata{:,marker1}+5),'fill');
    title(strcat('log(',marker1,{' '},'intensity)'));
    colormap(jet);colorbar;
    hold off;
else
    plusdata = framedata(framedata{:,gate1}==1,:);
    scatter(framedata.X,framedata.Y,15,'b','fill');
    scatter(plusdata.X,plusdata.Y,20,'r','fill');
    legend({'All cells','Positve cells'});
    hold off;
    title('Overlay with postive cells');
end