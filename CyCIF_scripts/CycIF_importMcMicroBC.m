function data1 = CycIF_importMcMicroBC(filename1,filename2,scale)
%%  CycIF import McMicro BC
%   Jerry Lin  2022/01/13
%
%   filename1: mcmacro data
%   filename2: mcmacro morphology data
%   scale: convert pixel to micron (default 0.32 for 20x no binning)
%   for Yu-An background substration
%

if nargin < 3
    scale = 0.32;
end

data1 = readtable(filename1);
data2 = readtable(filename2);
data1 = join(data1,data2,'keys','CellID','KeepOneCopy',{'X_centroid','Y_centroid'});

labels = data1.Properties.VariableNames;
labels = strrep(labels,'X_centroid','Xt');
labels = strrep(labels,'Y_centroid','Yt');
data1.Properties.VariableNames = labels;
data1.X = repmat(600,size(data1,1),1);
data1.Y = repmat(500,size(data1,1),1);
data1.Xt = data1.Xt * scale;
data1.Yt = data1.Yt * scale;
return