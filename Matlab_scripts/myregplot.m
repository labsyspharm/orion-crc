function [rho,pval]=myregplot(data1,data2,label1,label2)
%% My regression plots with pval & rho 
%  Jerry Lin 2019/03/18
%  Useage  figure,myregplot(data1,data2,label1,label2)
%           (data1,data2):: numerical data
%           (label1,label2)::  labels (xy)


%% Initializaiton

scatter(data1,data2,25,'b','fill');
lsline;
[rho,pval]=corr(data1,data2);

legend(strcat('r=',num2str(rho,'%0.2f'),';p=',num2str(pval,'%0.3f')));

xlabel(label1);
ylabel(label2);

return;



