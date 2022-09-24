function [h1,p]=myboxplot2t(data1,group1,grouporder,fontsize)
%% My function boxplot2
%  Jerry Lin 2020/04/17
%  Usage myboxplot2(groupdata,groups,grouporder)
%  2021/09/19 add features to array only plot

if nargin <=1
    h1 = boxplot(data1);
elseif nargin <=2
    h1=boxplot(data1,group1);
else
    h1=boxplot(data1,group1,'GroupOrder',grouporder);
end

ylims = ylim;
step1 = 0.1*(ylims(2)-ylims(1));
ylim([ylims(1),ylims(2)+2*step1]);
line([1,2],[ylims(2),ylims(2)],'LineWidth',1);

if nargin <=3
    fontsize = 12;
end

if nargin > 1
    group2 = grp2idx(group1);
    d1 = data1(group2==1);
    d2 = data1(group2==2);
else
    d1 = data1(:,1);
    d2 = data1(:,2);
end

%[~,p]=ttest2(d1,d2,'Vartype','unequal');
[~,p]=ttest2(d1,d2,'Vartype','unequal');

if p<0.05
    color1 ='r';
    fontsize = fontsize+2;
else
    color1 = 'k';
end

text(1.4,ylims(2)+step1,strcat('p=',num2str(p)),'FontSize',fontsize,'Color',color1);

return;
