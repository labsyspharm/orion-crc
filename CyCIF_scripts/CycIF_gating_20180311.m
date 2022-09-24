function [kmeangate,mygate,finegate]= CycIF_triplegate(datatable,marker)
%% Fucntion for single-channel gating with 3 different methods
%  Jerry Lin 2018/03/12


%% Initialization
temp1 = log(datatable{:,marker}+5);
pr1 = round(prctile(temp1,1),1);
pr99 = round(prctile(temp1,99),1);

%% Gating & Output
figure,

% Kmeangate
subplot(3,1,1);
Kmeangate(temp1,2,1);
xlim([pr1 pr99]);

% My findgate3
subplot(3,1,2);
findgate3(temp1,1,0.05,0);
xlim([pr1 pr99]);

%finegate
subplot(3,1,3);
finegate(temp1,0.01,1,pr1,pr99);
xlim([pr1 pr99]);
