function table1 = CycIF_ometif2table(filename,allchs,labels,scalefactor,rm_bg)
%% CycIF:  convert Montage to table
%  Jerry Lin 2019/03/18
%
%           filename--> ome.tif (recommand level 4)
%           allchs -->  channels (slices in ome tif)
%           labels -->  channel lables
%           scalefactor --> convert pixel to um (for 20x/level 4 = 8*0.65)
%           rm_bg -->  remove background or not
%

%% Initialization
table1=table;


%% Read all stacks
slice = 1;
for ch = 1:4
    for cyc = 1:round(allchs/4)
        temp1=imread(filename,(cyc-1)*4+ch);
        table1{:,labels{slice}}=double(temp1(:));
        slice = slice+1;
    end
end


%% Add position info  (AREA, X, Y, Xt, Yt)

AREA = scalefactor^2;
table1.AREA =  repmat(AREA,size(table1,1),1);
table1.CIRC = ones(size(table1,1),1);
%table1.X = repmat(702,size(table1,1),1);     %20x on RareCyte
%table1.Y = repmat(832,size(table1,1),1);     %20x on RareCyte

[xl,yl]=size(temp1);
allY = (repmat(1:xl,1,yl))';
allX = repmat(1:yl,xl,1);
allX = allX(:);

table1.X = allX;
table1.Y = allY;
table1.frame = ones(size(table1,1),1);
table1.COL = ones(size(table1,1),1);
table1.ROW = ones(size(table1,1),1);
table1.Xt = table1.X * scalefactor;
table1.Yt = table1.Y * scalefactor;

%% Remove background pixels (optional)

if rm_bg == true
    % remove all zeros
    flag1 = prod(table1{:,1:allchs}>50,2);
    flag1 = flag1 >0;
    table1 = table1(flag1,:);
    % remove low DAPI pixels
    flag1 = table1{:,1:allchs/4}>exp(7);
    flag1 = prod(flag1,2)>0;
    table1 = table1(flag1,:);
end

return;
