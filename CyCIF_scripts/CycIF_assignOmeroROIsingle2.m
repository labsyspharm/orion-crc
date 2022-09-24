function newtable = CycIF_assignOmeroROIsingle2(data1,filename,scale1,nameflag,marker1)
%% Script to read & assign ROI from Omero ROI (Yu-AN's script)
%  apply single ROI csv & data table
%  default scale1 = 0.65
%  Jerry Lin 2021/08/25

%data1 = eval(strcat('data',slideName{i}));

%filename = ROI_list{i};
%disp(filename);
%marker1 = 'ROI';

if nameflag == 1
    data1.ROIname = repmat({'none'},size(data1,1),1);
elseif ischar(nameflag)
    marker1 = nameflag;
end

data1{:,marker1} = zeros(size(data1,1),1);

p = 1;
[points,name1] = CycIF_omeROI2pointsText(filename,p,false);

tic;
while ~isempty(points)
    disp(size(points,1));
    points = points * scale1;
    
    %----simplify points------
    if(size(points,1)>100)
        flag1 = false(size(points,1),1);
        flag1(1:3:end) = true;
        points = points(flag1,:);
    end
    
    %---Test and assign points------    
    flag1 = inpolygon(data1.Xt,data1.Yt,points(:,1),points(:,2));
    data1{flag1,marker1} = repmat(p,sum(flag1),1);
    if nameflag==1
        data1.ROIname(flag1) = name1;
    end
    
    %---Read next ROI-------
    p = p+1;
    [points,name1] = CycIF_omeROI2pointsText(filename,p,false);
    toc;
end

newtable = data1;

return
