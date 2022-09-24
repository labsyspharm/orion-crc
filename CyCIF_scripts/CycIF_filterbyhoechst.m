%% filter by hoechst 
%  processing CycIF table based on the CV of all Hoechst stains
%  Jerry 2016/08/25

function output_table = CycIF_filterbyhoechst(input_table,ch_hoechst,int_cut)

% input_table --> data table form CycIF_readtable
% index for hoechst columns


allhoechst = input_table{:,ch_hoechst};
allcv = std(allhoechst,0,2) ./ mean(allhoechst,2);
meancv = mean(allcv);
stdcv = std(allcv);

allmean = mean(allhoechst,2);
idx = (allcv < (meancv + stdcv)) & (allmean > int_cut);

output_table = input_table(idx,:);

%outputhoechst = allhoechst(allcv < cv_cut,:);
%allmean = mean(allhoechst,2);
%output_table = output_table(allmean > 5000,:);
return;
