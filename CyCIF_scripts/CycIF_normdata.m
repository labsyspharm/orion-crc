function outtable = CycIF_normdata(intable)
%% for flat-filed correct in X direction only
% Jerry Lin 2017/10/27


%% Initialization

outtable = intable;

 names = intable.Properties.VariableNames;
 if ismember('AREA',names)
    idx = find(ismember(names,'AREA'))-1;
 else
    idx = find(ismember(names,'Area'))-1;
 end
 
 X10 = round(intable.X/10)*10;
 max_x = max(X10);
 
 for i = 1:idx
     % fit curve
     data = intable{:,i};
     tempdata = table(X10,data);
     %tempdata.data1 = outtable{:,i};
     %tempdata.X10 = X10;
     mean1 = varfun(@(X) prctile(X,10),tempdata,'GroupingVariable','X10','InputVariables','data');
     fc = polyfit(mean1.X10,mean1.Fun_data,3);
     
     max1 = max(polyval(fc,1:max_x));
     outtable{:,i} = intable{:,i} + max1 - polyval(fc,intable.X);
     %clear tempdata mean1 fc max1;
 end
 
 return;
 