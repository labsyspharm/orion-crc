function [pluscells, percentplus,predict1] = findplus(data1,ref1,zs,graph,mdl)
% Read data (numeric array) and find gate based on the reference
% channel(background) using gausian
% Jerry Lin 2017/03/07

%% Initialize variables.

if length(data1)>20000
   sampledata = datasample(data1,20000);
   sampleref = datasample(ref1,20000);
else
   sampledata = data1;
   sampleref = ref1;
end

%lmMdl = fitlm(ref1,data1,'RobustOpts','on');
if mdl==1
  mdl1 = fitrgp(sampleref,sampledata);
else
  mdl1 = fitlm(ref1,data1,'RobustOpts','on');
end

predict1 = predict(mdl1,ref1);


res1 = data1-predict1;

pluscells = res1>zs*mean(abs(res1));
percentplus = mean(pluscells);

if graph ==1
    figure;
    scatter(ref1(~pluscells),data1(~pluscells),10,'b','fill');
    hold on;
    scatter(ref1(pluscells),data1(pluscells),10,'r','fill');
end

return

