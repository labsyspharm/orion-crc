%% Plot all negative cells (Fig 3c)

data1 = dataC01;
data1.flag1 = sum(data1{:,labelp},2) ==0;
figure,CycIF_tumorview(data1,'flag1',8);
daspect([1 1 1]);
title('All negative cells');
ylabel([]);
xlabel([]);
set(gcf,'color','w');

%% HE prediction of negative cells (Fig 3d, allsamples)

flag1 = sum(allsample_re{:,labelp},2)==0;
temp1 = tabulate(allsample_re{flag1,'prediction_orion'});
bar(temp1(:,3));
ytickformat('percentage');
set(gca,'xticklabels',listMLclass);
set(gca,'xticklabelrotation',45);
grid on;
xlim([0.5 9.5]);
