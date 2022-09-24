function outtable = CycIF_normdata2D(intable)
%% for flat-filed correct in X direction only
% Jerry Lin 2017/10/27


%% Initialization

outtable = intable;

 names = intable.Properties.VariableNames;
 idx = find(ismember(names,'AREA'))-1;
 
 X10 = round(intable.X/10)*10;
 Y10 = round(intable.Y/10)*10;
 max_x = max(X10);
 max_y = max(Y10);
 
 %%Y-axis correation
 
  for i = 1:idx
     % fit curve
     data = intable{:,i};
     tempdata = table(Y10,data);
     %tempdata.data1 = outtable{:,i};
     %tempdata.X10 = X10;
     mean1 = varfun(@(X) prctile(X,10),tempdata,'GroupingVariable','Y10','InputVariables','data');
     fc = polyfit(mean1.Y10,mean1.Fun_data,3);
     
     max1 = max(polyval(fc,1:max_y));
     outtable{:,i} = intable{:,i} + max1 - polyval(fc,intable.Y);
     %clear tempdata mean1 fc max1;
 end
 
 %%X-axis correation
 
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
 