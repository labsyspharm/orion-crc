%% CycIF gating all
%  Need slidename & gateTable & doubeGates 
%  Gating each slide independently
%  Jerry Lin 2019/09/06
%
%  V3: for Cyto version
%

%% -- Initialization --

samplesize = input('Please input sample size:'); %5000;
allsample = table;
allmarkers = gateTable.Properties.VariableNames;

%allnames = gateTable.Properties.VariableNames;


%% -- Gating all  & resampling --

for i =2:size(gateTable,1)
        name1 = strcat('data',gateTable.slideName{i});
        %idx1 = find(ismember(gateTable.slideName,slideName{i}));
        
        disp(strcat('Gating:',name1));
        data1 = eval(name1);
        disp(strcat('Processing:',gateTable.slideName{i}));
        
        %--  Gating all channels (single-gate) --
        for g = 2:length(allmarkers)
            if gateTable{1,g}==0
                data1 = CycIF_setgate(data1,allmarkers{g},gateTable{i,g},'none');
            else
                data1{:,strcat(allmarkers{g},'p')} = data1{:,strcat('Cyto_',allmarkers{g})}>exp(gateTable{i,g});
            end    
        end
        
        %-- Double gating --
%         for j=1:size(doubleGates,1)
%             %gatename = strcat(doubleGates{i,1},'p',doubleGates{i,2},'p');
%             gate1 = strcat(doubleGates{j,1},'p');
%             gate2 = strcat(doubleGates{j,2},'p');
%             gatename = strcat(gate1,gate2);
%             data1{:,gatename}=data1{:,gate1} & data1{:,gate2};
%         end
        
        
        %-- Resampling --
        sample1 = datasample(data1,samplesize);
        eval(strcat('sample',gateTable.slideName{i},'=sample1;'));
        sample1.slidename = repmat(gateTable.slideName(i),length(sample1.X),1);
        if(isempty(allsample))
            allsample = sample1;
        else
            allsample = vertcat(allsample,sample1);
        end      
        
        %-- re-assign --
        eval(strcat(name1,'=data1;'));
end
