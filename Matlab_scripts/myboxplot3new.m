function h1=myboxplot3new(data1,group1,fontsize,grouporder)
%% My function boxplot3new
%  Jerry Lin 2021/02/03
%  Usage myboxplot3newgroupdata,groups,grouporder)
%  replace p values with symbols

if nargin <=2
    fontsize=10;
end

if nargin <=3
    h1=boxplot(data1,group1,'PlotStyle','compact');
else
    h1=boxplot(data1,group1,'GroupOrder',grouporder,'PlotStyle','compact');
end    

if nargin <=3
    group3 = grp2idx(group1);
else
    group3 = zeros(length(group1));
    group3(ismember(group1,grouporder{1}))=1;
    group3(ismember(group1,grouporder{2}))=2;
    group3(ismember(group1,grouporder{3}))=3;
end


ylims = ylim;
step1 = 0.1*(ylims(2)-ylims(1));
ylim([ylims(1),ylims(2)+4*step1]);
line([1.1,1.9],[ylims(2),ylims(2)],'LineWidth',1);
line([2.1,2.9],[ylims(2),ylims(2)],'LineWidth',1);
line([1.1,2.9],[ylims(2)+2*step1,ylims(2)+2*step1],'LineWidth',1);

d1 = data1(group3==1);
d2 = data1(group3==2);
d3 = data1(group3==3);

[~,p12]=ttest2(d1,d2,'Vartype','unequal');
[~,p23]=ttest2(d2,d3,'Vartype','unequal');
[~,p13]=ttest2(d1,d3,'Vartype','unequal');
p = p12;
if p < 0.001
    label1 = '***';
    clr1 = 'r';
elseif p < 0.01
    label1 = '**';
    clr1 = 'r';
elseif p < 0.05
    label1 = '*';
    clr1 = 'r';
else
    label1 = 'n.s.';
    clr1 = 'k';
end
text(1.3,ylims(2)+step1,label1,'FontSize',fontsize,'color',clr1);
p = p23;
if p < 0.001
    label1 = '***';
    clr1 = 'r';
elseif p < 0.01
    label1 = '**';
    clr1 = 'r';
elseif p < 0.05
    label1 = '*';
    clr1 = 'r';
else
    label1 = 'n.s.';
    clr1 = 'k';
end
text(2.3,ylims(2)+step1,label1,'FontSize',fontsize,'color',clr1);

p = p13;
if p < 0.001
    label1 = '***';
    clr1 = 'r';
elseif p < 0.01
    label1 = '**';
    clr1 = 'r';
elseif p < 0.05
    label1 = '*';
    clr1 = 'r';
else
    label1 = 'n.s.';
    clr1 = 'k';
end

text(1.8,ylims(2)+3*step1,label1,'FontSize',fontsize,'color',clr1);

return;
