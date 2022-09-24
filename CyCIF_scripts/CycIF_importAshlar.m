%%  CycIF_import_ashlar.m
%   Importing Ashlar assembled data
%   Jerry Lin 2017/12/14


%% Initialization

max_Cy = 9;
chs = 4;

alldata = cell(max_Cy,chs);

path1 = uigetdir('H:\26531POST\');

chnames = {'DAPI','FITC','Cy3','Cy5'};

%% Read csv/xls files
for ch =1:chs
    for cy = 1:max_Cy
        filename = strcat('Results-',chnames{ch},'-',num2str(cy),'.xls');
        filename = strcat(path1,'\',filename);
        display(strcat('opening:',filename));
        temp1 = CycIF_importxls(filename,2,inf);
        alldata{cy,ch}=temp1;
    end
end

clear temp1;

%% construct table;

for ch =1:chs
    for cy = 1:max_Cy
        temp1 = alldata{cy,ch};
        if exist('temp2','var')
            temp2 = horzcat(temp2,temp1.Mean);
        else
            temp2 = temp1.Mean;
        end
    end
end
temp2 = horzcat(temp2,temp1.Area);
temp2 = horzcat(temp2,temp1.Circ);
temp2 = horzcat(temp2,temp1.X);
temp2 = horzcat(temp2,temp1.Y);

table1 = array2table(temp2,'VariableNames',labels);
clear temp1 temp2;

