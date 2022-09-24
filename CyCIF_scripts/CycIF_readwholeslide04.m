%% Read whole slides (from ImageJ data)
%  required the variables :: labels
%  v4: require user inputs (name, cols, rows,chs); rename alldata;
%  Jerry Lin 2017/03/06


%% Initialization

%alldata = cell(rows,cols);

myDIR = uigetdir('D:\TRIPLET');

myName = input('Please input file name:','s');
cols = input('Columns=');
rows = input('Rows=');
chs = input('Channels=');
int_cut = input('Hoechst Intensity cutoff(suggested 1000)=');

alldata =table;
totalframe = rows*cols; %%rows*cols;
%%eachdata = cell(totalframe);

for i=1:totalframe;
  filename = strcat(myDIR,'\Results-',myName,'-',num2str(i),'.csv');
  if exist(filename,'file')
    temp1 = array2table(CycIF_readtable03(chs,filename),'VariableNames',labels);
    temp1 = CycIF_filterbyhoechst02(temp1,1:(chs/4-2),int_cut);
    temp1.frame = repmat(i,length(temp1.X),1);
    
    r = floor((i-1)/cols)+1;
    c = i - (r-1)*cols;
    
    temp1.COL = repmat(c,length(temp1.X),1);
    temp1.ROW = repmat(r,length(temp1.X),1);
    temp1.Xt = temp1.X + (c-1)* (1664);
    
    temp1.Yt = temp1.Y + (r-1)* 1404;
    
    
    if isempty(alldata);
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
eval('clear alldata');

