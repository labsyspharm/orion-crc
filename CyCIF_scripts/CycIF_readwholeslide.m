%% Read whole slides (from ImageJ data)
%  required the variables :: labels
%  v1: 2017/03/06  Jerry Lin
%  v4: require user inputs (name, cols, rows,chs); rename alldata;
%  v5: fix bugs & updates : 2017/08/16


%% Initialization

%alldata = cell(rows,cols);

myDIR = uigetdir('D:\TRIPLET');

myName = input('Please input file name:','s');
cols = input('Columns:');
rows = input('Rows:');
chs = input('Channels:');
int_cut = input('Hoechst Intensity cutoff(suggested 1000):');
mag = input('Please input magnefication(1=10x, 4=40x):');

alldata =table;
totalframe = rows*cols; %%rows*cols;

%% Create labels for each channels
if ~exist('labels','var')
    cy = chs /4;
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

%% read data files
for i=1:totalframe
  filename = strcat(myDIR,'\Results-',myName,'-',num2str(i),'.csv');
  if exist(filename,'file')
    temp1 = array2table(CycIF_readtable(chs,filename),'VariableNames',labels);
    temp1 = CycIF_filterbyhoechst(temp1,1:(chs/4-2),int_cut);
    temp1.frame = repmat(i,length(temp1.X),1);
    
    r = floor((i-1)/cols)+1;
    c = i - (r-1)*cols;
    
    temp1.COL = repmat(c,length(temp1.X),1);
    temp1.ROW = repmat(r,length(temp1.X),1);
    temp1.Xt = temp1.X + (c-1)* (1664/mag);
    
    temp1.Yt = temp1.Y + (r-1)* (1404/mag);
    
    
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
eval(strcat('DATA',myName,'=alldata;'));
clear alldata;

