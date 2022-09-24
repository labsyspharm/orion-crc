%% Read whole TMA slides (from ImageJ data)
%  
%  Jerry Lin 2016/09/21


%% Initialization

%rows = 11;
%cols = 13;
chs = 24;
labels ={'Hoechst1','Hoechst2','Hoechst3','Hoechst4','Hoechst5','Hoechst6','PCNA','CD31','pS6_240',...
    'EGFR','Ki67','MitoTracker','pH3','Keratin','FOXO1a','HER2','pCHK2','Actin555','p21','aSMA',...
    'HSF1a','CD45','pH2ax','HCSred','Area','Circ','X','Y'};
%alldata = cell(rows,cols);

myDIR = uigetdir('D:\TMATEST');

myName = 'Composite-TMA';


alldata =table;
totalframe = 103; %%rows*cols;
%%eachdata = cell(totalframe);
TMA=cell(totalframe,1);


for i=1:totalframe;
    filename = strcat(myDIR,'\Results-',myName,'-',num2str(i),'.csv');
    display(['Processing:',filename]);
    
    temp1 = array2table(CycIF_readtable03(chs,filename),'VariableNames',labels);
    temp1 = CycIF_filterbyhoechst01(temp1,1:chs/4,0.3);
    temp1.frame = repmat(i,length(temp1.X),1);
    TMA{i}=temp1;
    
    %r = floor((i-1)/cols)+1;
    %c = i - (r-1)*cols;
    
    %temp1.COL = repmat(c,length(temp1.X),1);
    %temp1.ROW = repmat(r,length(temp1.X),1);
    %temp1.Xt = temp1.X + (c-1)* (1664);
    
    %temp1.Yt = (1404-temp1.Y) + (r-1)* 1404;
        
    if isempty(alldata);
        alldata = temp1;
        %%eachdata{i} = temp1;
    else
        alldata = vertcat(alldata,temp1);
        %%eachdata{i} = temp1;
    end
    %display(['Processing:',filename]);
end


