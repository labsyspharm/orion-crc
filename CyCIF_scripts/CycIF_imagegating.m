function [pluscells gate]=CycIF_imagegating(data1,marker1,gatemethod,imagename,imagedir,scaling)
%% Display gating overlay with original images
%   data1 = data_table (eg. 'DATA25546ON');
%   marker1 = marker_name (eg. 'CD4');
%   gatemethod = 1(default) 2(kmeans)
%   imagename = image_name (eg. '25546ON')
%   imagedir = image_directory (eg. 'Y:\TRIPLET\25546ON')
%   scaling = scaling_factor (1 or 0.77)

%% Initial parameters

data2 = data1{:,marker1};

if(gatemethod == 1)
    figure,[pluscells,gate,~,~]=findgate3(log(data2+5),1,0.05,0);
else
    figure,[~,~,gate,pluscells]=kmeangate(log(data2+5),2,1);
end

gate1 = strcat(marker1,'p');
data1{:,gate1}=pluscells;

table1 = tabulate(data1{pluscells,'frame'});
table1 = sortrows(table1,2,'descend');
%topframe = table1(1,1);

for i=1:3:15
    frame=table1(i,1);
    image0=CycIF_imageoverlay(frame,data1,marker1,gate1,imagename,imagedir,scaling);
end
