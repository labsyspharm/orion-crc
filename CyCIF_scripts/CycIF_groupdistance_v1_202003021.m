%% CycIF calculate group distance
%  Jerry Lin 2020/03/21
%  
%  Calculate distance between all groups

%% Initialization

nogroup = input("Please input number of group:");

distable = table;

%% loop through all samples

for s=1:length(slideName)
    disp(strcat('Processing:',slideName{s}));
    data1 = eval(strcat('data',slideName{s}));
    disarray = NaN(nogroup);

    for i = 1:nogroup
        for j = 1:nogroup
            groupi = data1{data1.group==i,{'Xt','Yt'}};
            groupj = data1{data1.group==j,{'Xt','Yt'}};
            [idx,d]=knnsearch(groupi,groupj,'k',2);
            d = d(:,2);
            disarray(i,j)=mean(d);
        end
    end
    distable{s,1:nogroup*nogroup}=disarray(:)';
    distable{s,nogroup*nogroup+1}=slideName(s);
end

namearray = cell(nogroup,nogroup);

for i = 1:nogroup
    for j = 1:nogroup
        namearray{i,j}=strcat('g',num2str(i),'_g',num2str(j));
    end
end
namearray = namearray(:);
namearray{nogroup*nogroup+1}='slidename';
distable.Properties.VariableNames = namearray;


        
