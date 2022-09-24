%% Read whole slides (from ImageJ data)
%  required the variables :: labels
%  v2: require user inputs (name, cols, rows,chs); rename alldata;
%  Jerry Lin 2016/12/14


%% Initialization


myDIR = uigetdir('F:\OVA7');

myName = input('Please slide name:','s');
cs = input('Start cycle=');
ce = input('End cycle=');

allcount=table;
%totalframe = rows*cols; %%rows*cols;
%%eachdata = cell(totalframe);

for cyc=cs:ce;
    
    filename = strcat(myDIR,'\Count-Cycle',num2str(cyc),'.csv');
    temp1 = importcellcount(filename,2,inf);
    eval(strcat('allcount.cycle',num2str(cyc),'=temp1.Count;'));
        
    display(['Processing:',filename]);
end

eval(strcat('Count_',myName,'=allcount;'));
eval('clear allcount');

