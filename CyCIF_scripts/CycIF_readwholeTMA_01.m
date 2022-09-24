%% Read whole TMA slides after registration and stitching (from ImageJ data)
%  required the variables :: labels
%  
%  Jerry Lin 2017/07/25


%% Initialization

%alldata = cell(rows,cols);

myDIR = uigetdir('Z:\data\RareCyte\MELANOMATMA\');

myName = input('Please input file name:','s');
cores = input('Cores=');
cols = input('Columns=');
rows = input('Rows=');
chs = input('Channels=');
coresize = input('Core size(default:2000um)=');
int_cut = input('Hoechst Intensity cutoff(suggested 1000)=');


alldata =table;
%totalframe = cores; %%rows*cols;

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
for i=1:cores;
  filename = strcat(myDIR,'\Results-',myName,'-',num2str(i),'.csv');
  corename = strcat(myName,'-',num2str(i));
  if exist(filename,'file')
    temp1 = array2table(CycIF_readtable(chs,filename),'VariableNames',labels);
    temp1 = CycIF_filterbyhoechst(temp1,1:(chs/4-2),int_cut);
    temp1.frame = repmat(i,length(temp1.X),1);
    
    r = floor((i-1)/cols)+1;
    c = i - (r-1)*cols;
    
    
    temp1.COL = repmat(c,length(temp1.X),1);
    temp1.ROW = repmat(r,length(temp1.X),1);
    temp1.CORE = repmat(i,length(temp1.X),1);
    temp1.Xt = temp1.X + (c-1)* coresize;
    temp1.Yt = temp1.Y + (r-1)* coresize;
    
    temp1.CORENAME = repmat({corename},length(temp1.X),1);
    
    if isempty(alldata)
        alldata = temp1;
    else
        alldata = vertcat(alldata,temp1);
    end
  end  
  display(['Processing:',corename]);
end

myName = strrep(myName,'-','');
eval(strcat('data',myName,'=alldata;'));
clear alldata;

