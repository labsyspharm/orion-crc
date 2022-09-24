function [ROI,newtable] = CycIF_selectROI(oldtable,channel)

%% Interative select ROI
%  Jerry Lin 20220205

figure;

if size(oldtable,1)>50000
    datatable = datasample(oldtable,50000,'Replace',false);
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

ROI = drawpolygon;

flag1 = inpolygon(oldtable.Xt,oldtable.Yt,ROI.Position(:,1),ROI.Position(:,2));
newtable = oldtable(~flag1,:);

return;


