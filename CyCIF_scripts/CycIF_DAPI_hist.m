
%% DAPI plots
%% For CycIF data
%% 60/96 Well;

figure;
DAPI_ch=22;


for i=1:6
    for j=1:10
       subplot(6,10,(i-1)*10+j); 
       welllabel = strcat('row ',num2str(i),' col ',num2str(j+1));
       title(welllabel);
       DAPIdata = wellsum_nuc{i+1,j+1}(:,DAPI_ch);
       DAPIdata = DAPIdata(DAPIdata<5e6);
       histfit(log(DAPIdata),30,'kernel');
       xlim([13 15.5]);
    end
end