
%% Batch Read slides (from ImageJ data), using CSV guild file
%  required the variables : labels
%  
%  V3:  for Ashlar processed images
%  V4:  add feature (without scale images)
%  V5:  fix bug (for Ashlar images, no pixel unit)
%  V6:  UINT16 option
%
%  Jerry Lin 2021/08/07


%% Initialization

[filename,pathname] = uigetfile('*.csv','Select the CSV fies for slides');
slideTable = readtable(strcat(pathname,filename));
slideDIR = slideTable.Directory;
slideName = slideTable.Name;
colarray = slideTable.Cols;
rowarray = slideTable.Rows;
StepWarray = slideTable.StepW;
StepHarray = slideTable.StepH;

scalefactor = input('Please input resolution (4 for 40x, 2 for 20x, 1 for 10x, 0 for pixel):');
scalefree = input('Ashlar ouptut with scale (1 for yes, 0 for no):');
uint16flag = input('Convert all to uint16 (1 for yes, 0 for no):');
sslide = input('Please input the start number of slides:');
nslide = input('Please input the end number of slides:');
samples = input('Please input subsample size(default =10000):');
chs = input('Please input total cycles:');
chs = chs*4;


%xlims = 1664/scalefactor;    % dimension for 20x image on RareCyte
%ylims = 1404/scalefactor;    % dimension for 20x image on RareCyte

if scalefree ==0
    pixel2micron = 1.3/scalefactor;     % for 2x2 binning only
else
    pixel2micron = 1;
end

%chs = (slideTable.ce(1)-slideTable.cs(1)+1)*4;
int_cut = 2000;


%alldata = cell(rows,cols);
allsample = table;

%% Reading each slide

for slide = sslide:nslide
    
myDIR = strcat(slideDIR{slide},'\');

myName = slideName{slide}; %input('Please input file name:','s');
cols = colarray(slide); %input('Columns=');
rows = rowarray(slide); %input('Rows=');

if scalefactor>0
    xlims = 1664*StepWarray(slide)/1280/scalefactor;
    ylims = 1404*StepHarray(slide)/1080/scalefactor;
else
    xlims = StepWarray(slide);
    ylims = StepHarray(slide);
end

alldata =table;
totalframe = rows*cols; 

for i=1:totalframe
  filename = strcat(myDIR,'Results-',myName,'-',num2str(i),'.csv');
  if exist(filename,'file')
    temp1 = array2table(CycIF_readtable03(chs,filename),'VariableNames',labels);
    %temp1 = CycIF_filterbyhoechst02(temp1,1:(chs/4-1),int_cut);
    temp1.frame = repmat(i,length(temp1.X),1);
    
    r = floor((i-1)/cols)+1;
    c = i - (r-1)*cols;
    
    temp1.COL = repmat(c,length(temp1.X),1);
    temp1.ROW = repmat(r,length(temp1.X),1);
    temp1.Xt = temp1.X * pixel2micron + (c-1)* xlims;
    temp1.Yt = temp1.Y * pixel2micron + (r-1)* ylims;
    
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

if uint16flag ==1
    alldata{:,:} = uint16(alldata{:,:});
end

myName = strrep(myName,'-','');
sample1 = datasample(alldata,samples);
eval(strcat('data',myName,'=alldata;'));
eval(strcat('sample',myName,'=sample1;'));

sample1.slidename = repmat({myName},length(sample1.X),1);
if(isempty(allsample))
    allsample = sample1;
else
    allsample = vertcat(allsample,sample1);
end

clear alldata sample1;

end
clear samples rows cols slide temp1 totalframe r i c ch chs 


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


