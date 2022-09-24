function table1 = CycIF_gatingAllChs(input1,refGate,refGateValue,allChs)
%% For continuously setting gate using 2D method
%  Jerry Lin 2021/01/21


%% Inititlization

table1 = zeros(length(allChs),1);

for i = 1:length(allChs)
    flag1 = 'y';
    setGateValue = 0;
    setGate = allChs{i};
    while ismember(flag1,'y')
        [~,~,~,setGateValue,~]=CycIF_visualgate2D(input1,refGate,setGate,refGateValue,setGateValue);
        temp1 = input(strcat(setGate,'::Do you want to continue (0=n, 1=y):'));
        if temp1>0
            setGateValue=temp1;
            flag1 = 'y';
        else
            flag1 = 'n';
        end
    end
    close all;
    table1(i) = setGateValue;
end

table1 = CycIF_setgate(input1,setGate,setGateValue,'none');
return;

