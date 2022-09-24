

alldata_Cyto = [];

for i= 2:7;
    for j = 1:12;
        if(isempty(alldata_Cyto))
            alldata_Cyto = wellsum_Cyto{i,j};
        else
            alldata_Cyto = vertcat(alldata_Cyto,wellsum_Cyto{i,j});
        end
    end
end