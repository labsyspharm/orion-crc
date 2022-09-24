function data1 = CycIF_importMcMicro(filename,scale)
%%  CycIF import McMicro
%   Jerry Lin  2020/08/30
%
%   filename : mcmacro data
%   scale: convert pixel to micron (default 0.325 for 20x and 0.65 for binning)
%

if nargin < 2
    scale = 0.32;
end

data1 = readtable(filename);

labels = data1.Properties.VariableNames;
labels = strrep(labels,'X_centroid','Xt');
labels = strrep(labels,'Y_centroid','Yt');
data1.Properties.VariableNames = labels;
data1.X = repmat(600,size(data1,1),1);
data1.Y = repmat(500,size(data1,1),1);
data1.Xt = data1.Xt * scale;
data1.Yt = data1.Yt * scale;
return