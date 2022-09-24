%% Batch Read slides (from ImageJ data), using CSV guild file
%  required the variables : labels
% 
%  Jerry Lin 2018/02/03

%% Initialization

myDIR = uigetdir('C:\imagetemp','Please select the director');
myDIR = strcat(myDIR,'\');

myName = input('Please input file name/header:','s');
cy = input('Please input total cycles:');
chs = cy*4;

cols = input('How many columns:');
rows = input('How many rows:');

int_cut = input('Hoechst Intensity cutoff(suggested 2000):');
scalefactor = input('Please input resolution (4 for 40x, 2 for 20x, 1 for 10x):');
sampleno= input('Please input subsample size(default =10000):');

xlims = 1664/scalefactor;    % x dimension image on RareCyte
ylims = 1404/scalefactor;    % y dimension image on RareCyte

alldata =table;
totalframe = rows*cols; 

%% Create temporary labels for each channels

if ~exist('labels','var')
    flag =1;
    for ch=1:4
        names = {'Hoechst_','FITC_','Cy3_','Cy5_'};
        for i=1:cy
            labels(flag)= strcat(names(ch),num2str(i));
            flag = flag+1;
        end
    end
    labels = horzcat(labels,{'AREA','CIRC','X','Y'});
end

%% Read frame-by-frame

for i=1:totalframe
  filename = strcat(myDIR,'ResultsCilia-',myName,'-',num2str(i),'.csv');
  if exist(filename,'file')
    temp1 = array2table(CycIF_readtable03(chs,filename),'VariableNames',labels);
    temp1 = CycIF_filterbyhoechst02(temp1,1:(chs/4-2),int_cut);
    temp1.frame = repmat(i,length(temp1.X),1);
    
    r = floor((i-1)/cols)+1;
    c = i - (r-1)*cols;
    
    temp1.COL = repmat(c,length(temp1.X),1);
    temp1.ROW = repmat(r,length(temp1.X),1);
    temp1.Xt = temp1.X + (c-1)* xlims;
    temp1.Yt = temp1.Y + (r-1)* ylims;
    
    if isempty(alldata)
        alldata = temp1;
        %%eachdata{i} = temp1;
    else
        alldata = vertcat(alldata,temp1);
        %%eachdata{i} = temp1;
    end
  end  
  display(['Processing:',filename]);
end

myName = strrep(myName,'-','');
sample1 = datasample(alldata,sampleno);
eval(strcat('data',myName,'=alldata;'));
eval(strcat('sample',myName,'=sample1;'));

clear alldata sample1;

clear sampleno rows cols temp1 totalframe r i c ch chs cy


%% Function for reading imageJ table and convert to 2D array
% Jerry Lin 20160822
%
% all mean values plus Area, Circ, X, Y

function cycifarray = CycIF_readtable03(channels,myfilename)

%[filename,pathname] = uigetfile(mypath,'Select a CSV file');

imageJtable = CycIF_importcsv(myfilename,2,inf);

cellno = length(imageJtable{:,1})/channels;

allmeans = imageJtable.Mean;

cycifarray = reshape(allmeans,cellno,channels);

cycifarray(:,channels+1) = imageJtable.Area(1:cellno);
cycifarray(:,channels+2) = imageJtable.Circ(1:cellno);
cycifarray(:,channels+3) = imageJtable.X(1:cellno);
cycifarray(:,channels+4) = imageJtable.Y(1:cellno);

return;
end

%% filter by hoechst 
%  processing CycIF table based on the CV of all Hoechst stains
%  Jerry 2016/08/25

function output_table = CycIF_filterbyhoechst02(input_table,ch_hoechst,int_cut)

% input_table --> data table form CycIF_readtable
% index for hoechst columns


allhoechst = input_table{:,ch_hoechst};
allcv = std(allhoechst,0,2) ./ mean(allhoechst,2);
meancv = mean(allcv);
stdcv = std(allcv);

allmean = mean(allhoechst,2);
idx = (allcv < (meancv + stdcv)) & (allmean > int_cut);

output_table = input_table(idx,:);

%outputhoechst = allhoechst(allcv < cv_cut,:);
%allmean = mean(allhoechst,2);
%output_table = output_table(allmean > 5000,:);
return;
end


%% Function CycIF_importcsv
%  Jerry Lin 2016/08/25

function ResultsTable = CycIF_importcsv(filename, startRow, endRow)

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end


formatSpec = '%f%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%q%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
ResultsTable= table(dataArray{1:end-1}, 'VariableNames', {'VarName1','Label','Area','Mean','StdDev','Min','Max','X','Y','XM','YM','Perim','BX','BY','Width','Height','Major','Minor','Angle','Circ','Feret','IntDen','Median','Skew','Kurt','VarName26','RawIntDen','Slice','FeretX','FeretY','FeretAngle','MinFeret','AR','Round','Solidity'});
return;
end


