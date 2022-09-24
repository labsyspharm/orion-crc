
%% Hist plots
%% For CycIF data
%% 60/96 Well;

figure;
ch=4;
%text(10,10,channels(ch));
xmin = 3;
xmax = 9;

for i=1:8
    for j=1:12
       subplot(8,12,(i-1)*12+j); 
       welllabel = strcat('Well ',num2str(i),'-',num2str(j));
       %title(welllabel);
       data1 = wellsum_nuc{i,j}(:,ch);
       %data1 = data1(data1<5e6);
       histfit(log(data1+3),40,'kernel');
       xlim([xmin xmax]);
       title(welllabel);
    end
end
ps=ginput(1);
text(ps(1),ps(2),channelnames(ch));

