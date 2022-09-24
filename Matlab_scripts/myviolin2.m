function p = myviolin2(list1,list2,name1,name2,flag1,fontsize)
%%  My pairwise violin plot
%   jerry LIn 2022/03/31
%   Usage:  p = myviolin2(list1,list2,name1,name2,flag1,fontsize);
%

    if nargin <=5
        fontsize = 12;
    end
    
    if nargin <=4
        fontsize = 12;
        flag1 = false;
    end
    
    data1 = vertcat(list1,list2);
    group1 = vertcat(repmat({name1},length(list1),1),repmat({name2},length(list2),1));
    
    violinplot(data1,group1);
    ylims = ylim;
    step1 = 0.1*(ylims(2)-ylims(1));
    ylim([ylims(1),ylims(2)+2*step1]);
    line([1,2],[ylims(2),ylims(2)],'LineWidth',1,'Color','k');
    [~,p]=ttest2(list1,list2,'Vartype','equal');

    if p<0.05
        color1 ='r';
        fontsize = fontsize+2;
    else
        color1 = 'k';
    end
    
    if p >= 0.001 
        text(1.4,ylims(2)+step1,strcat('p=',num2str(p,'%0.3f')),'FontSize',fontsize,'Color',color1);
    else
        text(1.4,ylims(2)+step1,'p<0.001','FontSize',fontsize,'Color',color1);
    end

    if flag1
        hold on;
        for i = 1:length(list1)
            line([1,2],[list1(i),list2(i)],'Color',[0.5 0.5 0.5],'LineWidth',0.5);
        end
    end
    hold off;
    
return;