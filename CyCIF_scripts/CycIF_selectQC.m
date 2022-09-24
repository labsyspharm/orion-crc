function newtable = CycIF_selectQC(oldtable,channel)

%% Interative select ROI
%  Jerry Lin 20220205

sw1 = 1;
newtable = oldtable;

while sw1
    figure('units','normalized','outerposition',[0.5 0 0.5 1]);
    
    if size(newtable,1)>50000
        datatable = datasample(newtable,50000,'Replace',false);
    else
        datatable = oldtable;
    end

    CycIF_tumorview(datatable,channel,1);

    title('Digital Representation (log)');
    xl = xlim;
    yl = ylim;
    
    colormap(gca,gray);
    set(gca,'color','k');
    
    colorbar off;
    
    %sw1 = input('Select ROIs? (0=no;1=yes):');

    temp2 = questdlg('Select ROIs?', 'Selections', 'Yes','No','Yes');
    % Handle response
    switch temp2
        case 'Yes'
            sw1 = 1;
        case 'No'
            sw1 = 0;
    end

    if sw1
        ROI = drawpolygon;
        flag1 = inpolygon(newtable.Xt,newtable.Yt,ROI.Position(:,1),ROI.Position(:,2));
        newtable = newtable(~flag1,:);
    end
    close;
end

return;


