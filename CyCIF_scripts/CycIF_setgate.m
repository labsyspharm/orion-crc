function outtable = CycIF_setgate(intable,marker,gate,sum_m)
%% Set gating for CyCIF table
% Jerry Lin 2018/11/27
%
%   intable:  CycIF data table
%   marker:  marker/channel name (string)
%   gate:    gate value (log scale)
%   sum_m:   marker for summary
%

%% Initialization

outtable = intable;
gatename = strcat(marker,'p');

%% definte gate & summary

outtable{:,gatename}=outtable{:,marker}>exp(gate);

if ~strcmp(sum_m,'none')
    varfun(@mean,outtable,'GroupingVariable',sum_m,'InputVariables',gatename)
end

return;
 