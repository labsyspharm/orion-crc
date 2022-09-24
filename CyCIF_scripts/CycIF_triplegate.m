function [kmeangate1,mygate1,finegate1]= CycIF_triplegate(datatable,marker)
%% Fucntion for single-channel gating with 3 different methods
%  Jerry Lin 2018/03/12


%% Initialization
temp1 = log(datatable{:,marker}+5);
pr1 = round(prctile(temp1,1),1);
pr99 = round(prctile(temp1,99),1);

%% Gating & Output
h1=figure;
set(h1, 'Position', [1307 102 560 881]);

% Kmeangate
ax1=subplot(3,1,1);
[~,~,kmeangate1,~]=Kmeangate(temp1,2,1);
xlim([pr1 pr99+1]);
title('Kmeans');

% My findgate3
ax2=subplot(3,1,2);
[~,mygate1,~,~]=findgate3(temp1,1,0.05,0);
xlim([pr1 pr99+1]);
title('Findgate3');

%finegate
ax3=subplot(3,1,3);
[finegate1,~,~,~,]=finegate(temp1,0.01,1,pr1,pr99);
xlim([pr1 pr99+1]);
title('Fine gating');

linkaxes([ax1,ax2,ax3],'x');

return;
