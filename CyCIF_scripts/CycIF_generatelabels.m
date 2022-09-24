%% CycIF generate labels
% Jerry Lin 2017/8/16


function labels=CycIF_generatelabels(Cycles)

if ~exist('labels','var')
    cy = Cycles;
    flag =1;
    for ch=1:4
        names = {'Hoechst','FITC_','Cy3_','Cy5_'};
        for i=1:cy
            labels(flag)= strcat(names(ch),num2str(i));
            flag = flag+1;
        end
    end
    %labels = horzcat(labels,{'AREA','CIRC','X','Y'});
end

for i=cy+1:length(labels)
    prompt1 = ['Please input ',labels{i},':'];
    myName = input(prompt1,'s');
    if(length(myName)>0)
        labels(i) = {myName};
    end
end

labels = horzcat(labels,{'AREA','CIRC','X','Y'});
