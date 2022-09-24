function datatable=CycIF_readometif(filename,allchs,scalefactor,labels)
%% CycIF_readometif:: Convert Ashlared OME-TIFF to CycIF data (table format)
%  Jerry Lin 2019/03/18
%
%  Usage  datatable = CycIF_readometif(filename,chs,scalefactor,labels)
%                   datatable: output datatable 
%                   allchs: howmany channels (z in ometif)
%                   scalefactor: for converting x,y to real scale
%                   labels: a text cell array to put labels currently using
%                   the same label as original CycIF import
%                    (frame, COL, ROW, Xt, Yt are gnerated)

%% Initialization

datatable = table;
cycles = round(allchs/4);



%% reading all slices

for cy=1:cycles
    for ch=1:4
        slice = (cy-1)*4+ch;
        temp1 = imread(filename,slice);
        allx = repmat((1:size(temp1,2))',size(temp1,1),1);
        ally = repmat((1:size(temp1,1))',1,size(temp1,2));
        
        temp1 = temp1(:);
        
        if ~exist(imagearray,'var')
            
        else
            


